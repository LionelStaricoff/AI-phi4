FROM ubuntu:22.04

# Variables
ENV MODEL=SmolLM2-135M-Q4_0.gguf
ENV MODEL_URL=https://huggingface.co/HuggingFaceTB/SmolLM2-135M-Instruct-GGUF/resolve/main/SmolLM2-135M-Q4_0.gguf
ENV PORT=8080

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Descargar y compilar llama.cpp
WORKDIR /app
RUN git clone https://github.com/ggerganov/llama.cpp . \
    && cmake -B build \
    && cmake --build build --config Release

# Descargar modelo
RUN mkdir -p /models && \
    wget -O /models/${MODEL} ${MODEL_URL}

# Instalar servidor Python para API
COPY requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Copiar script de servidor
COPY server.py /app/server.py

# Exponer puerto
EXPOSE ${PORT}

# Ejecutar API
CMD ["python3", "server.py", "--model", "/models/SmolLM2-135M-Q4_0.gguf", "--port", "8080"]
