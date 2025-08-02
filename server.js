const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.post('/create_video', (req, res) => {
  const { title, audio_url } = req.body;
  if (!title || !audio_url) {
    return res.status(400).json({ error: 'Missing title or audio_url' });
  }

  // Simula a geração de um vídeo
  const video_url = `https://example.com/videos/${encodeURIComponent(title)}.mp4`;
  res.json({ video_url });
});

app.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});
