extends Node

@export var game_music_path: String
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	if audio_player:
		if not audio_player.stream:
			audio_player.stream = load(game_music_path)
		audio_player.connect("finished", Callable(self, "_on_audio_finished"))
		audio_player.play()

func _on_audio_finished():
	if audio_player:
		audio_player.play()
		
func start_game_music():
	if audio_player:
		if not audio_player.is_playing():
			audio_player.play()

func stop_game_music():
	if audio_player:
		if audio_player.is_playing():
			audio_player.stop()
