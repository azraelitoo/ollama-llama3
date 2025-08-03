FROM python:3.11-slim

# Instala dependências básicas
RUN apt-get update && \
    apt-get install -y ffmpeg curl git && \
    rm -rf /var/lib/apt/lists/*

# Instala o LocalAI (simples para produção)
RUN curl -L https://github.com/go-skynet/LocalAI/releases/latest/download/local-ai-linux-amd64 -o /usr/local/bin/local-ai && \
    chmod +x /usr/local/bin/local-ai

# Cria pastas
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
RUN mkdir -p videos images /models

# Expõe as portas para Flask (8000) e LocalAI (8080)
EXPOSE 8000 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
