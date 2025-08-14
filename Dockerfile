FROM debian:bookworm

# Variables de entorno
ENV PORT=8000
ENV MODEL=Phi-4-14B-Q4_K_M.gguf

# Instalar dependencias necesarias para compilar llama.cpp y descargar modelos
RUN apt-get update && apt-get install -y \
    git build-essential cmake wget curl pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Clonar y compilar llama.cpp
RUN git clone https://github.com/ggerganov/llama.cpp /app/llama.cpp \
    && cd /app/llama.cpp \
    && cmake -B build \
    && cmake --build build --config Release

# Crear carpeta de modelos y descargar el modelo cuantizado GGUF
RUN mkdir -p /app/models \
    && wget -O /app/models/$MODEL \
    https://huggingface.co/bartowski/Phi-4-14B-GGUF/resolve/main/Phi-4-14B.Q4_K_M.gguf

# Exponer puerto
EXPOSE 8000

# Ejecutar el servidor HTTP de llama.cpp
CMD ["/app/llama.cpp/build/bin/llama-server", \
    "--model", "/app/models/Phi-4-14B-Q4_K_M.gguf", \
    "--port", "8000", \
    "--host", "0.0.0.0", \
    "--ctx-size", "4096"]
