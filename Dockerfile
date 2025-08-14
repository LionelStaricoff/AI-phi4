FROM ubuntu:22.04

# Variables de entorno
ENV MODEL=tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf
ENV HF_MODEL_URL=https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    python3 \
    python3-pip \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Directorio de trabajo
WORKDIR /app

# Clonar y compilar llama.cpp
RUN git clone https://github.com/ggerganov/llama.cpp . \
    && cmake -B build \
    && cmake --build build --config Release

# Descargar el modelo público
RUN mkdir -p /models && \
    wget -O /models/${MODEL} ${HF_MODEL_URL}

# Copiar dependencias Python
COPY requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Copiar el servidor Python
COPY server.py /app/server.py

# Exponer puerto
EXPOSE 8000

# Comando de inicio
CMD ["python3", "server.py"]
