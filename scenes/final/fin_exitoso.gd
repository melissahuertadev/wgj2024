extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Detener la música del juego si está sonando
	var global_audio_manager = get_node("/root/GlobalAudioManager")
	if global_audio_manager:
		global_audio_manager.stop_game_music()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
