extends Control

@onready var animation_player : AnimationPlayer = $AnimationPlayer
#@export var intro_duration : float = 30.0  # Duración total de la intro en segundos

func _ready():
	animation_player.play("intro_animation")

#func _process(delta):
	#if animation_player.current_animation_position >= intro_duration:
		#get_tree().change_scene("res://path/to/next_scene.tscn")
