FROM python:3.11-slim

# Instala o ffmpeg e limpa cache de pacotes
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# Define o diretório de trabalho
WORKDIR /app

# Copia todos os arquivos para o container
COPY . .

# Instala as dependências Python
RUN pip install flask requests

# Garante que as pastas de saída existam
RUN mkdir -p videos images

# Expõe a porta 8000 (a mesma usada pelo Flask)
EXPOSE 8000

# Comando para iniciar a aplicação
CMD ["python", "app.py"]
