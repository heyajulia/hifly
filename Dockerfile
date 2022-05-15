FROM python:3.9-alpine AS build

RUN mkdir /app
WORKDIR /app
RUN apk add --no-cache curl
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
COPY pyproject.toml poetry.lock ./
RUN $HOME/.poetry/bin/poetry export -o requirements.txt

FROM python:3.9-alpine

RUN mkdir /app
WORKDIR /app
COPY --from=build --chown=nobody:nobody /app/requirements.txt .
RUN apk add --no-cache build-base && pip install --no-cache-dir -r requirements.txt && apk del build-base
COPY --chown=nobody:nobody main.py .
USER nobody
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "1"]
EXPOSE 8000
