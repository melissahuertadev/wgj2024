extends Node2D
@onready var boton_continuar = $Button
@onready var descansar_prompt : TextEdit = $PromptText

func _ready():
	# Conectar el botón "CONTINUAR" a la función que cambiará la escena (NECESARIO!!! no solamente el fun on press)
	boton_continuar.connect("pressed", Callable(self, "_on_button_pressed"))

	if Global.player_eligio_descansar:
		descansar_prompt.text = "Descansaré en la sala de comandos, a ver que pasa..."
	else:
		descansar_prompt.text = "Saliendo de la sala de comandos."

func _on_button_pressed():
	get_tree().change_scene_to_file("res://escenaprincipal.tscn")

	# HAY PROBLEMAS CON EL QUEUE NO USAR!!!!!!!!!!!!!! 
	#var current_scene = get_tree().current_scene
	#if current_scene:
	#	current_scene.queue_free()  # Esto asegura que la escena actual se elimine correctamente
	#get_tree().change_scene_to_file("res://escenaprincipal1.tscn")
