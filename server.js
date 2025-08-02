const express = require('express');
const { exec } = require('child_process');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.post('/create_video', (req, res) => {
  const { title, audio_url, image_url } = req.body;

  if (!title || !audio_url || !image_url) {
    return res.status(400).json({ error: 'Missing title, audio_url or image_url' });
  }

  const videoName = `${encodeURIComponent(title)}.mp4`;
  const imageFile = '/tmp/image.png';
  const audioFile = '/tmp/audio.mp3';
  const outputFile = `/tmp/${videoName}`;

  // Baixa os arquivos (áudio e imagem)
  const downloadCommand = `
    curl -s -o "${imageFile}" "${image_url}" &&
    curl -s -o "${audioFile}" "${audio_url}"
  `;

  exec(downloadCommand, (err) => {
    if (err) return res.status(500).json({ error: 'Failed to download files' });

    const ffmpegCommand = `ffmpeg -loop 1 -i "${imageFile}" -i "${audioFile}" -c:v libx264 -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p -shortest "${outputFile}" -y`;

    exec(ffmpegCommand, (err2) => {
      if (err2) return res.status(500).json({ error: 'Failed to generate video' });

      return res.json({ video_url: `https://example.com/fake-url/${videoName}` });
    });
  });
});

app.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});
