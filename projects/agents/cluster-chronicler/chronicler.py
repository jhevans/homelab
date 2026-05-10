import os
import json
import time
import requests
from kubernetes import client, config, watch

# Configuration
OLLAMA_URL = os.getenv("OLLAMA_URL")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "llama3.2:1b")

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

def generate_narrative(event_data):
    """Call Ollama to generate a human-friendly narrative of the event."""
    prompt = f"""
You are the 'Cluster Chronicler', an AI assistant for a home lab. 
Your job is to translate technical Kubernetes events into a friendly, narrative sentence.

Context: {event_data['context']}
Technical Event: {event_data['reason']} for {event_data['object']} in namespace {event_data['namespace']}.
Message: {event_data['message']}

Instruction: Write a single, concise, and friendly sentence describing what happened. Use the Context to make it more personal.
Narrative:"""

    try:
        response = requests.post(
            f"{OLLAMA_URL}/api/generate",
            json={
                "model": OLLAMA_MODEL,
                "prompt": prompt,
                "stream": False
            },
            timeout=30
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
        print("   (Tip: Run 'kubectl port-forward -n ai svc/ollama-cpu 11434:11434' to connect)")

    mapping = load_context()
    v1 = client.CoreV1Api()
    w = watch.Watch()

    print(f"📺 Watching for Cluster Events using model '{OLLAMA_MODEL}'...")

    try:
        for event in w.stream(v1.list_event_for_all_namespaces):
            obj = event['object']
            
            # Filter for only 'Normal' or 'Warning' events to reduce noise
            if obj.type not in ['Normal', 'Warning']:
                continue

            event_data = {
                "reason": obj.reason,
                "message": obj.message,
                "namespace": obj.metadata.namespace,
                "object": obj.involved_object.name,
                "context": get_context(obj.involved_object.name, mapping)
            }

            # Generate and print the narrative
            narrative = generate_narrative(event_data)
            
            print(f"📖 {narrative}")
            print(f"   (Technical: {event_data['namespace']}/{event_data['object']} -> {event_data['reason']})\n")

    except Exception as e:
        print(f"❌ Error watching events: {e}")

if __name__ == "__main__":
    main()
