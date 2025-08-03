FROM python:3.11-slim

# Instala ffmpeg e remove cache
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# Define diretório de trabalho
WORKDIR /app

# Copia os arquivos do projeto
COPY . .

# Instala dependências
RUN pip install flask requests gunicorn

# Cria diretórios para saída
RUN mkdir -p videos images

# Expõe a porta padrão do Railway
EXPOSE 8000

# Executa com servidor WSGI de produção
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8000"]
