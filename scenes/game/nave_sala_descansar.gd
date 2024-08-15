extends Node2D

@onready var descansar_prompt : TextEdit = $PromptText

var escena_nave_interior = preload("res://scenes/game/nave_interior.tscn")

func _ready():
	if Global.player_eligio_descansar:
		descansar_prompt.text = "Descansaré en la sala de comandos, a ver que pasa..."
	else:
		descansar_prompt.text = "Saliendo de la sala de comandos."
	
	# Esperar 2 segundos y luego cambiar de escena
	await get_tree().create_timer(2.0).timeout
	_on_timer_timeout()

func _on_timer_timeout():
	# Instanciar la escena precargada y cambiar a ella
	var nueva_escena = escena_nave_interior.instantiate()
	get_tree().current_scene.queue_free()  # Opcional: libera la escena actual
	get_tree().get_root().add_child(nueva_escena)
