FROM ubuntu:22.04

# Evita prompts interativos
ENV DEBIAN_FRONTEND=noninteractive

# Instala dependências: Node, FFmpeg e utilitários
RUN apt-get update && apt-get install -y \
    curl \
    nodejs \
    npm \
    ffmpeg \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Cria diretório da aplicação
WORKDIR /app

# Copia arquivos do projeto
COPY . .

# Instala dependências do Node.js
RUN npm install

# Expõe a porta
EXPOSE 3000

# Comando de inicialização
CMD ["npm", "start"]
