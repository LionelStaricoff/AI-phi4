import argparse
from fastapi import FastAPI
from pydantic import BaseModel
from llama_cpp import Llama
import uvicorn

app = FastAPI()

class PromptRequest(BaseModel):
    prompt: str
    max_tokens: int = 128

llm = None

@app.post("/v1/completions")
async def generate(request: PromptRequest):
    output = llm(
        request.prompt,
        max_tokens=request.max_tokens,
        stop=["</s>"]
    )
    return {"text": output["choices"][0]["text"]}

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", type=str, required=True)
    parser.add_argument("--port", type=int, default=8080)
    args = parser.parse_args()

    global llm
    llm = Llama(model_path=args.model, n_threads=4)

    uvicorn.run(app, host="0.0.0.0", port=args.port)
