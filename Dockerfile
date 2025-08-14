FROM python:3.11-slim

# Instalar dependencias
RUN pip install --no-cache-dir vllm

# Establecer variables para forzar CPU
ENV VLLM_USE_MODELSCOPE=false
ENV VLLM_LOGGING_LEVEL=DEBUG
ENV VLLM_DEVICE=cpu

# Servir el modelo directamente en runtime
CMD ["vllm", "serve", "ai/phi4:14B-Q4_0", "--port", "8000", "--device", "cpu"]
