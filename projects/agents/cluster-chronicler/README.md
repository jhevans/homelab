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

## 📦 Deployment

To update the agent in the cluster, rebuild and push the Docker image:

```bash
docker build -t jhevans28/cluster-chronicler:latest .
docker push jhevans28/cluster-chronicler:latest
```

Once pushed, trigger a job to test the latest version:

```bash
kubectl create job --from=cronjob/cluster-chronicler test-run -n ai
```

## 🏗️ Project Structure
- `chronicler.py`: The core logic for watching events and (eventually) talking to Ollama.
- `requirements.txt`: Python dependencies.
- `context/`: (Planned) Directory for RAG documentation context.
