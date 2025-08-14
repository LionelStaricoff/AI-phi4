FROM python:3.11-slim

RUN pip install vllm

# Descarga y prepara el modelo phi4
RUN vllm download ai/phi4:14B-Q4_0

# Ejecuta un servidor API en el puerto 8000
CMD ["vllm", "serve", "ai/phi4:14B-Q4_0", "--port", "8000"]
