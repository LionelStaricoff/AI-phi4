FROM ubuntu:22.04

# Variables de entorno (pueden cambiarse en build)
ARG HF_TOKEN
ENV HF_TOKEN=${HF_TOKEN}
ENV MODEL=tu_modelo.gguf
ENV HF_MODEL_URL=https://huggingface.co/usuario/repositorio/resolve/main/tu_modelo.gguf

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

# Descargar el modelo con token
RUN mkdir -p /models && \
    wget --header="Authorization: Bearer ${HF_TOKEN}" \
    -O /models/${MODEL} ${HF_MODEL_URL}

# Copiar dependencias Python
COPY requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Copiar el servidor Python
COPY server.py /app/server.py

# Exponer puerto
EXPOSE 8000

# Comando de inicio
CMD ["python3", "server.py"]
