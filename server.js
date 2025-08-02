const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.post('/create_video', (req, res) => {
  const { title, audio_url } = req.body;
  if (!title || !audio_url) {
    return res.status(400).json({ error: 'Missing title or audio_url' });
  }

  // Simulação de criação do vídeo
  const videoUrl = `https://example.com/videos/${title.replace(/\s+/g, '_')}.mp4`;

  res.json({ video_url: videoUrl });
});

app.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});
