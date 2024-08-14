extends Node2D

@onready var boton_no_hay_nada = $Button_NoHayNada
@onready var boton_hay_algo = $Button_HayAlgo

func _ready():
	print("readyy.",  Global.sprite_seleccionado)
	# Conectar la lógica para cuando el jugador elige "Creo que no hay nada aquí" "Creo que hay algo aquí"
	boton_no_hay_nada.connect("pressed", Callable(self, "_on_button_no_hay_nada_pressed")) 
	boton_hay_algo.connect("pressed", Callable(self, "_on_button_hay_algo_pressed"))

func _on_button_no_hay_nada_pressed():
	print("NO HAY,..",  Global.sprite_seleccionado)
	Global.player_eligio_descansar = true
	if Global.sprite_seleccionado != null and Global.sprite_seleccionado != Global.sprite_anomalianull:
		player_ha_perdido()
	else:
		player_acumula_aciertos()

func _on_button_hay_algo_pressed():
	print("HAY ALGO, sprite seleccionad..",  Global.sprite_seleccionado)
	Global.player_eligio_descansar = false
	if Global.sprite_seleccionado != null and Global.sprite_seleccionado != Global.sprite_anomalianull:
		player_acumula_aciertos()
	else:
		player_ha_perdido()
	
func player_acumula_aciertos():
	Global.contador_aciertos += 1
	if Global.contador_aciertos >= Global.dias_por_sobrevivir + 1:
		player_ha_ganado()
	else:
		get_tree().change_scene_to_file("res://Escenas/dormir.tscn")
	
func player_ha_perdido():
	print("perdio, sprite seleccionad..",  Global.sprite_seleccionado)
	Global.contador_aciertos = 0
	get_tree().change_scene_to_file("res://escenaprincipal.tscn") 

func player_ha_ganado():
	# Cambiar a la escena de victoria
	var err = get_tree().change_scene_to_file("res://scenes/final/fin_exitoso.tscn")
	
	if err != OK:
		print("Error al cambiar a la escena fin_exitoso: ", err)
	else:
		print ("HAS GANADO!!!!!")
