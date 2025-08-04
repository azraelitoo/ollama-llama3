from TTS.api import TTS
import sys

texto = sys.argv[1]
saida = sys.argv[2]

tts = TTS(model_name="tts_models/multilingual/multi-dataset/xtts_v2", progress_bar=False)
tts.tts_to_file(text=texto, file_path=saida)
