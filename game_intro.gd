extends Control

@onready var animation_player : AnimationPlayer = $AnimationPlayer
# Duración total de la intro en segundos
@export var intro_duration : float = 1.0

func _ready():
	animation_player.play("intro_animation")

func _process(delta):
	if animation_player.current_animation_position >= intro_duration:
		get_tree().change_scene_to_file("res://escenaprincipal.tscn")
