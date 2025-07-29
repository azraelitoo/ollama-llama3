# Usa imagem oficial do Ollama
FROM ollama/ollama

# Faz o download do modelo LLaMA3 ao buildar
RUN ollama pull llama3

# Expondo a porta padrão
EXPOSE 11434

# Inicia o Ollama
CMD ["ollama", "serve"]
