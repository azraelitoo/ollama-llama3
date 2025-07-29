FROM ubuntu:22.04

# Instala dependências básicas + curl
RUN apt update && apt install -y curl wget unzip git sudo

# Baixa o Ollama e instala
RUN curl -fsSL https://ollama.com/download/Ollama-linux.zip -o ollama.zip \
  && unzip ollama.zip \
  && mv ollama /usr/local/bin/ollama \
  && chmod +x /usr/local/bin/ollama \
  && rm -rf ollama.zip

# Puxa o modelo no início do container (não durante o build!)
CMD ollama serve & sleep 5 && ollama pull llama3 && tail -f /dev/null