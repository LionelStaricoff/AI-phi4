FROM debian:bullseye-slim

# Variables de entorno
ENV PORT=8000
ENV MODEL=Phi-4-14B-Q4_K_M.gguf

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    git build-essential cmake wget curl \
    && rm -rf /var/lib/apt/lists/*

# Descargar y compilar llama.cpp
RUN git clone https://github.com/ggerganov/llama.cpp /app/llama.cpp \
    && cd /app/llama.cpp \
    && cmake -B build -DGGML_BLAS=OFF \
    && cmake --build build --config Release

# Crear carpeta de modelos y descargar el modelo GGUF
RUN mkdir -p /app/models \
    && wget -O /app/models/$MODEL https://huggingface.co/bartowski/Phi-4-14B-GGUF/resolve/main/Phi-4-14B.Q4_K_M.gguf

# Exponer puerto
EXPOSE 8000

# Comando para servir como API HTTP
CMD ["/app/llama.cpp/build/bin/llama-server", \
    "--model", "/app/models/Phi-4-14B-Q4_K_M.gguf", \
    "--port", "8000", \
    "--host", "0.0.0.0", \
    "--ctx-size", "4096"]
