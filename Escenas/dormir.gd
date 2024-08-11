extends Node2D
@onready var boton_volver = $Button

func _ready():
	# Conectar el botón "volver" a la función que cambiará la escena (NECESARIO!!! no solamente el fun on press)
	boton_volver.connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed():
	get_tree().change_scene_to_file("res://escenaprincipal1.tscn")

	# HAY PROBLEMAS CON EL QUEUE NO USAR!!!!!!!!!!!!!! 
	#var current_scene = get_tree().current_scene
	#if current_scene:
	#	current_scene.queue_free()  # Esto asegura que la escena actual se elimine correctamente
	#get_tree().change_scene_to_file("res://escenaprincipal1.tscn")
