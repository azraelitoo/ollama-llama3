FROM python:3.11-slim

# Instala ffmpeg
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

# Define diretório de trabalho
WORKDIR /app

# Copia tudo para o container
COPY . .

# Instala dependências
RUN pip install flask requests

# Cria pasta de saída de vídeos
RUN mkdir -p videos

# Expõe a porta usada no app.py
EXPOSE 8000

# Comando para iniciar o servidor Flask
CMD ["python", "app.py"]
