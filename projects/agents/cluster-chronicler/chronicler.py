import os
import json
import time
from datetime import datetime, timedelta, timezone
import requests
from kubernetes import client, config

# Configuration
OLLAMA_URL = os.getenv("OLLAMA_URL")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "llama3.2:1b")
WINDOW_HOURS = int(os.getenv("WINDOW_HOURS", "6"))

def load_context():
    """Load the mapping of service names to descriptions."""
    try:
        context_path = os.path.join(os.path.dirname(__file__), 'context', 'mapping.json')
        with open(context_path, 'r') as f:
            return json.load(f)
    except Exception as e:
        print(f"⚠️ Could not load context mapping: {e}")
        return {}

def get_context(obj_name, mapping):
    """Find a matching description for the given object name."""
    obj_name_lower = obj_name.lower()
    for key, description in mapping.items():
        if key in obj_name_lower:
            return description
    return "An unknown component of the lab."

def generate_summary(events_summary):
    """Call Ollama to generate a high-signal summary."""
    if not events_summary:
        return "The cluster is humming along nicely with no major changes or issues."

    prompt = f"""
Summarize these Kubernetes events in NO MORE than two sentences.
- Mention only NEWly created services or CLEARLY BREAKING issues.
- Use the 'context' provided to identify the purpose of the apps.
- If everything looks like standard scaling or setup, say 'The cluster is humming along nicely.'
- DO NOT use greetings, chatty introductions, or sign-offs.

Events:
{json.dumps(events_summary)}
"""

    try:
        response = requests.post(
            f"{OLLAMA_URL}/api/generate",
            json={
                "model": OLLAMA_MODEL,
                "prompt": prompt,
                "stream": False
            },
            timeout=300
        )
        if response.status_code == 200:
            return response.json().get('response', '').strip()
        else:
            return f"Error from Ollama: {response.status_code}"
    except Exception as e:
        return f"Could not reach Ollama: {e}"

def main():
    global OLLAMA_URL
    # 1. Load Kubernetes Configuration
    try:
        config.load_incluster_config()
        if not OLLAMA_URL:
            OLLAMA_URL = "http://ollama-cpu.ai.svc.cluster.local:11434"
        print(f"✅ Running in-cluster. Target Ollama: {OLLAMA_URL}")
    except config.ConfigException:
        config.load_kube_config()
        if not OLLAMA_URL:
            OLLAMA_URL = "http://localhost:11434"
        print(f"🏠 Running locally. Target Ollama: {OLLAMA_URL}")

    mapping = load_context()
    v1 = client.CoreV1Api()

    print(f"⌛ Gathering events from the last {WINDOW_HOURS} hours...")
    
    start_time = datetime.now(timezone.utc) - timedelta(hours=WINDOW_HOURS)
    
    try:
        events = v1.list_event_for_all_namespaces()
        relevant_events = []
        
        # Routine noise to ignore completely
        NOISE_REASONS = [
            'ArtifactUpToDate', 'ReconciliationSucceeded', 'Pulling', 'Pulled', 
            'Scheduled', 'Started', 'Created', 'Killing', 'Progressing'
        ]

        for obj in events.items:
            # Check if event is within our window
            event_time = obj.last_timestamp or obj.event_time or obj.metadata.creation_timestamp
            if not event_time or event_time < start_time:
                continue

            # Only care about Warnings or specific creation events
            if obj.type != 'Warning' and obj.reason not in ['SuccessfulCreate', 'Failed']:
                continue
            
            if obj.reason in NOISE_REASONS:
                continue

            relevant_events.append({
                "reason": obj.reason,
                "message": obj.message,
                "namespace": obj.metadata.namespace,
                "object": obj.involved_object.name,
                "context": get_context(obj.involved_object.name, mapping)
            })

        # Limit to the most recent 20 events to avoid prompt truncation and timeouts
        relevant_events = relevant_events[-20:]

        report = generate_summary(relevant_events)
        
        print("\n" + "="*40)
        print(f"📖 CLUSTER CHRONICLE: {datetime.now().strftime('%Y-%m-%d %H:%M')}")
        print("="*40)
        print(f"\n{report}\n")
        print("="*40)

    except Exception as e:
        print(f"❌ Error processing events: {e}")

if __name__ == "__main__":
    main()
