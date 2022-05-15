from typing import Optional

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root(name: Optional[str] = "World"):
    return {"message": f"Hi, {name}!"}
