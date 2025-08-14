FROM ghcr.io/ggerganov/llama.cpp:server

# Variables de entorno
ENV PORT=8000
ENV MODEL=Phi-4-14B-Q4_K_M.gguf

# Instalar wget y descargar modelo GGUF
USER root
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /models \
    && wget -O /models/$MODEL \
    https://huggingface.co/bartowski/Phi-4-14B-GGUF/resolve/main/Phi-4-14B.Q4_K_M.gguf

# Exponer puerto
EXPOSE 8000

# Arrancar llama-server con el modelo
CMD ["--model", "/models/Phi-4-14B-Q4_K_M.gguf", \
    "--port", "8000", \
    "--host", "0.0.0.0", \
    "--ctx-size", "4096"]
