FROM ai/smollm2:latest

# Expone el puerto de la API
EXPOSE 8000

# Arranca el servidor HTTP de la IA en todas las interfaces
CMD ["--api", "--port", "8000", "--host", "0.0.0.0"]
