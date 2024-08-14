extends Node

@export var audio_file_path: String

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	# Asignar el archivo de audio si no está asignado
	if not audio_player.stream:
		audio_player.stream = load(audio_file_path)

	# Conectar la señal 'finished' para repetir el audio
	audio_player.connect("finished", Callable(self, "_on_audio_finished"))

	# Iniciar la reproducción
	audio_player.play()

func _on_audio_finished():
	# Reiniciar la reproducción cuando el audio termine
	audio_player.play()
