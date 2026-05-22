# Use a slim Python image for a smaller footprint
FROM python:3.14-slim

# Create a non-root user for security (Learning Outcome: Secure Containers)
RUN useradd -m chronicler
USER chronicler
WORKDIR /home/chronicler

# Install dependencies
COPY --chown=chronicler:chronicler requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Copy the source code and context
COPY --chown=chronicler:chronicler chronicler.py .
COPY --chown=chronicler:chronicler context/ context/

# Ensure the bin directory is in the PATH for the non-root user
ENV PATH="/home/chronicler/.local/bin:${PATH}"

# Set the target Ollama URL for in-cluster use
ENV OLLAMA_URL="http://ollama-cpu.ai.svc.cluster.local:11434"

# Run the agent
CMD ["python", "chronicler.py"]
