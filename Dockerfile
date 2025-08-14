FROM ghcr.io/ggerganov/llama.cpp:server

ENV PORT=8000
ENV MODEL=Phi-4-14B-Q4_K_M.gguf
ARG HF_TOKEN
ENV HF_TOKEN=${HF_TOKEN}

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /models \
    && wget --header="Authorization: Bearer ${HF_TOKEN}" \
    -O /models/$MODEL \
    https://huggingface.co/bartowski/TheDrummer_Gemma-3-R1-27B-v1-GGUF/blob/main/TheDrummer_Gemma-3-R1-27B-v1-IQ2_M.gguf

EXPOSE 8000

CMD ["--model", "/models/Phi-4-14B-Q4_K_M.gguf", \
    "--port", "8000", \
    "--host", "0.0.0.0", \
    "--ctx-size", "4096"]
