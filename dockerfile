FROM ubuntu:22.04

# Instala dependências básicas
RUN apt-get update && apt-get install -y curl unzip

# Instala o Ollama
RUN curl -fsSL https://ollama.com/download/Ollama-linux.zip -o ollama.zip \
  && unzip ollama.zip \
  && mv ollama /usr/local/bin/ollama \
  && chmod +x /usr/local/bin/ollama \
  && rm -rf ollama.zip

# Expõe a porta padrão
EXPOSE 11434

# Inicia o servidor e baixa o modelo
CMD ollama serve & sleep 5 && ollama pull llama3 && tail -f /dev/null
