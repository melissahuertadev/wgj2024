extends Node2D

@onready var boton_no_hay_nada = $Button_NoHayNada
@onready var boton_hay_algo = $Button_HayAlgo

func _ready():
	# Conectar la lógica para cuando el jugador elige "Creo que no hay nada aquí" "Creo que hay algo aquí"
	boton_no_hay_nada.connect("pressed", Callable(self, "_on_button_no_hay_nada_pressed")) 
	boton_hay_algo.connect("pressed", Callable(self, "_on_button_hay_algo_pressed"))

func _on_button_no_hay_nada_pressed():
	Global.player_eligio_descansar = true
	#print("Global.sprite_seleccionado", Global.sprite_seleccionado)
	#print("Global.sprite_anomalianul", Global.sprite_anomalianull)
	if Global.sprite_seleccionado != null and Global.sprite_seleccionado != Global.sprite_anomalianull:
		Global.contador_aciertos = 0
		print("Contador de aciertos reiniciado a:", Global.contador_aciertos)
		get_tree().reload_current_scene()
	else:
		Global.contador_aciertos += 1
		print("Contador de aciertos incrementado a:", Global.contador_aciertos)
		get_tree().change_scene_to_file("res://Escenas/dormir.tscn")

func _on_button_hay_algo_pressed():
	Global.player_eligio_descansar = false
	if Global.sprite_seleccionado != null and Global.sprite_seleccionado != Global.sprite_anomalianull:
		Global.contador_aciertos += 1
		print("Contador de aciertos incrementado a:", Global.contador_aciertos)
		get_tree().change_scene_to_file("res://Escenas/dormir.tscn")
	else:
		Global.contador_aciertos = 0
		print("Contador de aciertos reiniciado a:", Global.contador_aciertos)
		get_tree().reload_current_scene()
