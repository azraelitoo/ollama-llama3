from flask import Flask, request, jsonify, send_from_directory
import requests
import os
import subprocess
from datetime import datetime

app = Flask(__name__)
os.makedirs("videos", exist_ok=True)
os.makedirs("images", exist_ok=True)  # NOVO: diretório de imagens

# --- Rotas para servir arquivos ---
@app.route('/videos/<path:filename>')
def serve_video(filename):
    return send_from_directory("videos", filename)

@app.route('/images/<path:filename>')
def serve_image(filename):
    return send_from_directory("images", filename)

# --- Utilitários ---
def baixar_arquivo(url, destino):
    try:
        print(f"[DEBUG] Baixando: {url} → {destino}")
        r = requests.get(url, stream=True, timeout=15)
        r.raise_for_status()
        with open(destino, 'wb') as f:
            for chunk in r.iter_content(1024):
                f.write(chunk)
        print(f"[OK] Arquivo salvo: {destino}")
        return True
    except Exception as e:
        print(f"[ERRO] Falha ao baixar {url}: {e}")
        return False

def obter_duracao_em_segundos(arquivo_audio):
    try:
        comando = [
            "ffprobe", "-v", "error",
            "-show_entries", "format=duration",
            "-of", "default=noprint_wrappers=1:nokey=1",
            arquivo_audio
        ]
        resultado = subprocess.run(comando, stdout=subprocess.PIPE, text=True)
        duracao = float(resultado.stdout.strip())
        print(f"[INFO] Duração do áudio: {duracao:.2f}s")
        return duracao
    except Exception as e:
        print(f"[ERRO] ffprobe falhou: {e}")
        return 60.0

# --- Endpoint: Geração de Vídeo com imagem ---
@app.route('/create_video', methods=['POST'])
def criar_video():
    data = request.get_json()
    if not data or 'audio_url' not in data or 'title' not in data:
        return jsonify({'error': 'Parâmetros ausentes'}), 400

    audio_url = data['audio_url']
    title = data['title']
    image_url = data.get('image_url', 'https://i.imgur.com/V3tDbpO.jpeg')

    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    base = f"{title}_{timestamp}".replace(" ", "_")
    audio_path = f"{base}.mp3"
    image_path = f"{base}.jpg"
    video_sem_audio = f"videos/{base}_sem_audio.mp4"
    video_final = f"videos/{base}_final.mp4"

    if not baixar_arquivo(audio_url, audio_path):
        return jsonify({'error': 'Erro ao baixar áudio'}), 500
    if not baixar_arquivo(image_url, image_path):
        return jsonify({'error': 'Erro ao baixar imagem'}), 500

    duracao = obter_duracao_em_segundos(audio_path)

    cmd_img_video = [
        "ffmpeg", "-y",
        "-loop", "1",
        "-framerate", "1",
        "-i", image_path,
        "-t", str(duracao),
        "-vf", "scale=1280:720,format=yuv420p",
        "-c:v", "libx264",
        "-r", "25",
        "-pix_fmt", "yuv420p",
        "-movflags", "+faststart",
        video_sem_audio
    ]
    print(f"[1/2] Criando vídeo visual: {' '.join(cmd_img_video)}")
    subprocess.run(cmd_img_video, check=True)

    cmd_merge = [
        "ffmpeg", "-y",
        "-i", video_sem_audio,
        "-i", audio_path,
        "-c:v", "copy",
        "-c:a", "aac",
        "-b:a", "192k",
        "-shortest",
        "-movflags", "+faststart",
        video_final
    ]
    print(f"[2/2] Adicionando áudio: {' '.join(cmd_merge)}")
    subprocess.run(cmd_merge, check=True)

    for temp_file in [audio_path, image_path, video_sem_audio]:
        if os.path.exists(temp_file):
            os.remove(temp_file)
            print(f"[LIMPEZA] Removido: {temp_file}")

    video_url = f"https://{request.host}/videos/{os.path.basename(video_final)}"

    return jsonify({
        "success": True,
        "video_url": video_url
    }), 200

# --- NOVO: Endpoint de geração de imagem com texto ---
@app.route('/create_image', methods=['POST'])
def criar_imagem():
    data = request.get_json()
    if not data or 'title' not in data or 'prompt' not in data:
        return jsonify({'error': 'Parâmetros ausentes'}), 400

    title = data['title']
    prompt = data['prompt']
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    base = f"{title}_{timestamp}".replace(" ", "_")
    output_path = f"images/{base}.png"

    # Corrigir apóstrofos para evitar quebra do ffmpeg
    text = f"{title} - {prompt}".replace("'", "’")

    cmd = [
        "ffmpeg", "-y",
        "-f", "lavfi",
        "-i", "color=c=black:s=1280x720",
        "-vf", f"drawtext=text='{text}':fontcolor=white:fontsize=36:x=(w-text_w)/2:y=(h-text_h)/2",
        "-frames:v", "1",
        output_path
    ]

    try:
        print(f"[FFMPEG] Criando imagem com texto: {' '.join(cmd)}")
        subprocess.run(cmd, check=True)
    except Exception as e:
        return jsonify({'error': f'Erro ao gerar imagem: {e}'}), 500

    image_url = f"https://{request.host}/images/{os.path.basename(output_path)}"
    return jsonify({
        "success": True,
        "image_url": image_url
    }), 200

# --- Executar app ---
if __name__ == '__main__':
    port = int(os.environ.get("PORT", 8000))
    app.run(host="0.0.0.0", port=port)
