FROM python:3.11-slim

# Instala ffmpeg e dependências básicas
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# Define diretório de trabalho
WORKDIR /app

# Copia arquivos para dentro do container
COPY . .

# Instala dependências Python
RUN pip install flask requests

# Garante que as pastas de saída existam
RUN mkdir -p videos images

# Expõe a porta padrão usada no app Flask
EXPOSE 8000

# Comando para rodar o servidor Flask
CMD ["python", "app.py"]
