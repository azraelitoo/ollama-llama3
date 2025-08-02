FROM ubuntu:22.04

# Instala dependências básicas
RUN apt-get update && apt-get install -y curl unzip nodejs npm

# Instala o Ollama
RUN curl -fsSL https://ollama.com/download/Ollama-linux.zip -o ollama.zip \
  && unzip ollama.zip \
  && mv ollama /usr/local/bin/ollama \
  && chmod +x /usr/local/bin/ollama \
  && rm -rf ollama.zip

# Cria pasta do app e copia arquivos Node.js
WORKDIR /app
COPY . /app
RUN npm install

# Expõe a porta para o backend e para o Ollama
EXPOSE 3000
EXPOSE 11434

# Inicia Ollama em segundo plano e depois o servidor Node
CMD ollama serve & \
    sleep 5 && ollama pull llama3 && \
    node server.js
