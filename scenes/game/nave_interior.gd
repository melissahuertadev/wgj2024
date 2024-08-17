extends Control

var fondos = [
	"res://assets/images/sala_de_comando_scene/screen.png",
	"res://assets/images/vitrina_scene/screen.png",
	"res://assets/images/puerta_scene/screen.png"
]

var indice_actual = 0  # Índice del fondo actual

@onready var background_rect = $BackgroundRect
@onready var puerta_rect = $PuertaTextureRect
@onready var final_button = $FinalButton  

#sprite anomalias
@onready var sprite_p1_tablero_anomalia = $SpriteP1Tablero
@onready var sprite_p1_silla_anomalia = $SpriteP1Silla
@onready var sprite_p2_vitrina_anomalia = $SpriteP2Vitrina
@onready var sprite_p2_planta_anomalia = $SpriteP2Planta


@onready var sprite_anomalia3 = $SpriteAnomalia3
@onready var sprite_anomalianull = $SpriteAnomalianull
@onready var label_dia = $LabelDia 

#sala de comando
var texturas_anomalia1 = [
	load("res://assets/images/sala_de_comando_scene/silla1.png"),
]

#vitrina
var texturas_anomalia2 = [
	load("res://assets/images/vitrina_scene/alien1.png"),
]

#puerta
var texturas_anomalia3 = [
	load("res://assets/images/puerta_scene/flor1.png"),
]

var contador = 0  # Pra los clicks en los sprites
var sprite_seleccionado = null  # Referencia al sprite que se hará visible
var ultimo_sprite = null  # Almacena el último sprite seleccionado para evitar repeticiones
#var sprite_clickeado = false  

func _ready():
	var global_audio_manager = get_node("/root/GlobalAudioManager")
	if global_audio_manager:
		global_audio_manager.start_game_music()
		
	ocultar_todas_las_anomalias()
	Global.sprite_clickeado = false  # Resetea la variable al iniciar la escena
	Global.sprite_anomalianull = sprite_anomalianull
	
	if Global.contador_aciertos == 0:
		Global.sprite_seleccionado = null

	if Global.contador_aciertos < Global.dias_por_sobrevivir + 1:
		seleccionar_sprite_aleatorio()
		cambiar_fondo_actual()
		actualizar_texto_dia()


# #####################################################SelecciónDelScriptDeAcuerdo al sprite global

# Función para seleccionar aleatoriamente un sprite y una textura
func seleccionar_sprite_aleatorio():
	if Global.contador_aciertos > 0:
		var opciones = [sprite_anomalianull, sprite_p1_silla_anomalia, sprite_p2_vitrina_anomalia, sprite_anomalia3]
		var nuevas_opciones = opciones.filter(func(opcion):
			return opcion != ultimo_sprite
			)

		if nuevas_opciones.size() > 0:
			Global.sprite_seleccionado = nuevas_opciones[randi() % nuevas_opciones.size()]
		else:
			Global.sprite_seleccionado = null
			ultimo_sprite = Global.sprite_seleccionado
			#Global.sprite_seleccionado = sprite_seleccionado
			ocultar_todas_las_anomalias()

func ocultar_todas_las_anomalias():
	sprite_p1_silla_anomalia.visible = false
	sprite_p2_vitrina_anomalia.visible = false
	sprite_anomalia3.visible = false
	sprite_anomalianull.visible = false
	# Seleccionar aleatoriamente una textura para el sprite seleccionado
	#if Global.sprite_seleccionado == sprite_p1_silla_anomalia:
	#	sprite_p1_silla_anomalia.texture = texturas_anomalia1[randi() % texturas_anomalia1.size()]
	#	sprite_p1_silla_anomalia.visible = true
	#elif Global.sprite_seleccionado == sprite_p2_vitrina_anomalia:
	#	sprite_p2_vitrina_anomalia.texture = texturas_anomalia2[randi() % texturas_anomalia2.size()]
	#	sprite_p2_vitrina_anomalia.visible = true
	#elif Global.sprite_seleccionado == sprite_anomalia3:
	#	sprite_anomalia3.texture = texturas_anomalia3[randi() % texturas_anomalia3.size()]
	#	sprite_anomalia3.visible = true
	#elif Global.sprite_seleccionado == sprite_anomalianull:
#		sprite_anomalianull.visible = true

# Función para cambiar la textura del fondo actual
func cambiar_fondo_actual():
	background_rect.texture = load(fondos[indice_actual])

	sprite_p1_silla_anomalia.visible = false
	sprite_p2_vitrina_anomalia.visible = false
	sprite_anomalia3.visible = false

	# Solo muestra el sprite seleccionado si corresponde al fondo actual
	if indice_actual == 0 and Global.sprite_seleccionado == sprite_p1_silla_anomalia:
		sprite_p1_silla_anomalia = true
	elif indice_actual == 1 and Global.sprite_seleccionado == sprite_p2_vitrina_anomalia:
		sprite_p2_vitrina_anomalia.visible = true
	elif indice_actual == 2 and Global.sprite_seleccionado == sprite_anomalia3:
		sprite_anomalia3.visible = true
		

	# Verificar si estamos en la última imagen
	if indice_actual == fondos.size() - 1:
		puerta_rect.visible = true
		final_button.visible = true
	else:
		puerta_rect.visible = false
		final_button.visible = false

# Funciones de los botones
func _on_button_siguiente_pressed():
	indice_actual += 1
	if indice_actual >= fondos.size():
		indice_actual = 0
	cambiar_fondo_actual()

func _on_button_anterior_pressed():
	indice_actual -= 1
	if indice_actual < 0:
		indice_actual = fondos.size() - 1
	cambiar_fondo_actual()

func _on_final_button_pressed():
	puerta_rect.visible = false
	
	if Global.sprite_seleccionado != null:
		# Mueve el sprite al nodo raíz para que no se libere al cambiar de escena
		Global.sprite_seleccionado.get_parent().remove_child(Global.sprite_seleccionado)
		get_tree().root.add_child(Global.sprite_seleccionado)
	
	#1. Aparecer modal con opciones..
	#2. Si hace click en quedarse a descansar.... mostrar sala de comando, anomalia no debe estar en el 1er cuadro
	#3. Si hace click en salir de la sala, hacer animacion de la puerta

	get_tree().change_scene_to_file("res://scenes/game/nave_puerta_decision.tscn")
	final_button.visible = false
	
func actualizar_texto_dia():
	# Actualiza el texto del Label con el valor del contador global
	label_dia.text = "Día " + str(Global.contador_aciertos)
