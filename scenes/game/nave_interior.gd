extends Control

var fondos = [
	"res://assets/images/sala_de_comando_scene/screen.png",
	"res://assets/images/vitrina_scene/screen.png",
	"res://assets/images/puerta_scene/screen.png"
]

var indice_actual = 0  # Índice del fondo actual

@onready var background_rect = $BackgroundRect
@onready var puerta_rect = $PuertaTextureRect
@onready var label_dia = $LabelDia 
@onready var final_button = $FinalButton  

#sprite anomalias
@onready var sprite_p1_tablero_anomalia = $SpriteP1Tablero
@onready var sprite_p1_silla_anomalia = $SpriteP1Silla
@onready var sprite_p2_vitrina_anomalia = $SpriteP2Vitrina
@onready var sprite_p2_planta_anomalia = $SpriteP2Planta
@onready var sprite_p3_mesa_anomalia = $SpriteP3Mesa
@onready var sprite_p3_almohada_anomalia = $SpriteP3Almohada
@onready var sprite_anomalianull = $SpriteAnomalianull



#sala de comando
var texturas_silla = [
	load("res://assets/images/sala_de_comando_scene/anomalias/p1_silla_1.png")
]
var texturas_tablero = [
	load("res://assets/images/sala_de_comando_scene/anomalias/p1_tablero_0.png"),
	load("res://assets/images/sala_de_comando_scene/anomalias/p1_tablero_1.png")
]

#vitrina
var texturas_planta = [
	load("res://assets/images/vitrina_scene/anomalias/p2_planta_0.png"),
	load("res://assets/images/vitrina_scene/anomalias/p2_planta_1.png")
]
var texturas_vitrina = [
	load("res://assets/images/vitrina_scene/anomalias/p2_vitrina_1.png")
]

#puerta
var texturas_almohada = [
	load("res://assets/images/puerta_scene/anomalias/p3_almohada_0.png"),
	load("res://assets/images/puerta_scene/anomalias/p3_almohada_1.png"),
]

var texturas_mesa = [
	load("res://assets/images/puerta_scene/anomalias/p3_mesa_0.png"),
	load("res://assets/images/puerta_scene/anomalias/p3_mesa_1.png"),
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
		var opciones = [sprite_anomalianull, sprite_p1_tablero_anomalia, sprite_p1_silla_anomalia, sprite_p2_vitrina_anomalia,  sprite_p2_planta_anomalia, sprite_p3_mesa_anomalia, sprite_p3_almohada_anomalia]
		print("optiones", opciones)
		var nuevas_opciones = opciones.filter(func(opcion):
			return opcion != ultimo_sprite
		)

		print("nuevas opciones", nuevas_opciones)

		if nuevas_opciones.size() > 0:
			Global.sprite_seleccionado = nuevas_opciones[randi() % nuevas_opciones.size()]
		else:
			Global.sprite_seleccionado = null
			ultimo_sprite = Global.sprite_seleccionado
			Global.sprite_seleccionado = sprite_seleccionado
			ocultar_todas_las_anomalias()
		
		print("el sprite seleccionado es ...", Global.sprite_seleccionado)
	# Seleccionar aleatoriamente una textura para el sprite seleccionado
	if Global.sprite_seleccionado == sprite_p1_silla_anomalia:
		sprite_p1_silla_anomalia.texture = texturas_silla[randi() % texturas_silla.size()]
		sprite_p1_silla_anomalia.visible = true
	elif Global.sprite_seleccionado == sprite_p1_tablero_anomalia:
		sprite_p1_tablero_anomalia.texture = texturas_tablero[randi() % texturas_tablero.size()]
		sprite_p1_tablero_anomalia.visible = true
	elif Global.sprite_seleccionado == sprite_p2_vitrina_anomalia:
		sprite_p2_vitrina_anomalia.texture = texturas_vitrina[randi() % texturas_vitrina.size()]
		sprite_p2_vitrina_anomalia.visible = true
	elif Global.sprite_seleccionado == sprite_p2_planta_anomalia:
		sprite_p2_planta_anomalia.texture = texturas_planta[randi() % texturas_planta.size()]
		sprite_p2_planta_anomalia.visible = true
	elif Global.sprite_seleccionado == sprite_p3_almohada_anomalia:
		sprite_p3_almohada_anomalia.texture = texturas_almohada[randi() % texturas_almohada.size()]
		sprite_p3_almohada_anomalia.visible = true
	elif Global.sprite_seleccionado == sprite_p3_mesa_anomalia:
		sprite_p3_mesa_anomalia.texture = texturas_mesa[randi() % texturas_mesa.size()]
		sprite_p3_mesa_anomalia.visible = true
	elif Global.sprite_seleccionado == sprite_anomalianull:
		sprite_anomalianull.visible = true

# Función para cambiar la textura del fondo actual
func cambiar_fondo_actual():
	background_rect.texture = load(fondos[indice_actual])
	ocultar_todas_las_anomalias()

	# Solo muestra el sprite seleccionado si corresponde al fondo actual
	if indice_actual == 0:
		if Global.sprite_seleccionado == sprite_p1_tablero_anomalia:
			sprite_p1_tablero_anomalia.visible = true
		elif Global.sprite_seleccionado == sprite_p1_silla_anomalia:
			sprite_p1_silla_anomalia.visible = true
	elif indice_actual == 1:
		if Global.sprite_seleccionado == sprite_p2_vitrina_anomalia:
			sprite_p2_vitrina_anomalia.visible = true
		elif Global.sprite_seleccionado == sprite_p2_planta_anomalia:
			sprite_p2_planta_anomalia.visible = true
	elif indice_actual == 2:
		if Global.sprite_seleccionado == sprite_p3_mesa_anomalia:
			sprite_p3_mesa_anomalia.visible = true
		elif Global.sprite_seleccionado == sprite_p3_almohada_anomalia:
			sprite_p3_almohada_anomalia.visible = true
	
	handle_ultimo_panel()

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


## Helpers

# Ocultar todas las anomalias
func ocultar_todas_las_anomalias():
	sprite_p1_silla_anomalia.visible = false
	sprite_p1_tablero_anomalia.visible = false
	sprite_p2_vitrina_anomalia.visible = false
	sprite_p2_planta_anomalia.visible = false
	sprite_p3_mesa_anomalia.visible = false
	sprite_p3_almohada_anomalia.visible = false
	sprite_anomalianull.visible = false

# Verificar si estamos en el ultimo panel
func handle_ultimo_panel():
	if indice_actual == fondos.size() - 1:
		puerta_rect.visible = true
		final_button.visible = true
	else:
		puerta_rect.visible = false
		final_button.visible = false
