FROM python:3.11-slim

RUN pip install vllm

# Al iniciar el contenedor, servirá el modelo y lo descargará
CMD ["vllm", "serve", "ai/phi4:14B-Q4_0", "--port", "8000", "--device", "cpu"]
