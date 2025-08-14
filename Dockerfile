# Imagen base
FROM ubuntu:22.04

# Variables de entorno
ENV MODEL=SmolLM2-135M-Q4_0.gguf
ENV HF_MODEL_URL=https://huggingface.co/HuggingFaceTB/SmolLM2-135M-Instruct-GGUF/resolve/main/SmolLM2-135M-Q4_0.gguf

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

# Crear carpeta de trabajo
WORKDIR /app

# Clonar y compilar llama.cpp
RUN git clone https://github.com/ggerganov/llama.cpp . \
    && cmake -B build \
    && cmake --build build --config Release

# Descargar el modelo
RUN mkdir -p /models && \
    wget -O /models/${MODEL} ${HF_MODEL_URL}

# Copiar requisitos de Python
COPY requirements.txt /app/requirements.txt

# Instalar dependencias de Python
RUN pip3 install --no-cache-dir -r requirements.txt

# Copiar script del servidor
COPY server.py /app/server.py

# Exponer puerto para la API
EXPOSE 8000

# Comando para ejecutar el servidor
CMD ["python3", "server.py"]
