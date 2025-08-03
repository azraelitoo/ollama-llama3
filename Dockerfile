FROM python:3.11-slim

# Instala dependências básicas
RUN apt-get update && \
    apt-get install -y ffmpeg curl git nodejs npm && \
    rm -rf /var/lib/apt/lists/*

# Instala o LocalAI (binário)
RUN curl -L https://github.com/go-skynet/LocalAI/releases/latest/download/local-ai-linux-amd64 -o /usr/local/bin/local-ai && \
    chmod +x /usr/local/bin/local-ai

# Aumenta memória disponível para subprocessos Node.js
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Diretório de trabalho
WORKDIR /app

# Copia tudo e instala dependências Python
COPY . .
RUN pip install --no-cache-dir -r requirements.txt

# Cria pastas
RUN mkdir -p videos images /models

# Expõe portas para Flask e LocalAI
EXPOSE 8000 8080

# Inicia o app Flask via gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
