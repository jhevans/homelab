# 📝 Cluster Chronicler

A "throwaway" learning agent that translates Kubernetes events into a human-readable narrative.

## 🎓 Learning Outcomes
1.  **Secure Containers:** Running as a non-root user with minimal RBAC.
2.  **Basic RAG:** Context-aware prompting using local documentation.
3.  **Event-Driven Agency:** Reacting to real-time cluster state changes.

## 🚀 Local Development

1. **Install Dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Run the Chronicler:**
   ```bash
   python chronicler.py
   ```

## 🏗️ Project Structure
- `chronicler.py`: The core logic for watching events and (eventually) talking to Ollama.
- `requirements.txt`: Python dependencies.
- `context/`: (Planned) Directory for RAG documentation context.
