extends Control

var fondos = [
	"res://assets/images/sala_de_comando_scene/screen.png",
	"res://assets/images/vitrina_scene/screen.png",
	"res://assets/images/puerta_scene/screen.png"
]

var indice_actual = 0  # Índice del fondo actual

@onready var background_rect = $BackgroundRect
@onready var final_button = $FinalButton  
#sprite anomalias
@onready var sprite_anomalia1 = $SpriteAnomalia1
@onready var sprite_anomalia2 = $SpriteAnomalia2
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
		var opciones = [sprite_anomalianull, sprite_anomalia1, sprite_anomalia2, sprite_anomalia3]
		var nuevas_opciones = opciones.filter(func(opcion):
			return opcion != ultimo_sprite
			)

		if nuevas_opciones.size() > 0:
			Global.sprite_seleccionado = nuevas_opciones[randi() % nuevas_opciones.size()]
		else:
			Global.sprite_seleccionado = null
			ultimo_sprite = Global.sprite_seleccionado
			#Global.sprite_seleccionado = sprite_seleccionado
			sprite_anomalia1.visible = false
			sprite_anomalia2.visible = false
			sprite_anomalia3.visible = false
			sprite_anomalianull.visible = false


	# Seleccionar aleatoriamente una textura para el sprite seleccionado
	#if Global.sprite_seleccionado == sprite_anomalia1:
	#	sprite_anomalia1.texture = texturas_anomalia1[randi() % texturas_anomalia1.size()]
	#	sprite_anomalia1.visible = true
	#elif Global.sprite_seleccionado == sprite_anomalia2:
	#	sprite_anomalia2.texture = texturas_anomalia2[randi() % texturas_anomalia2.size()]
	#	sprite_anomalia2.visible = true
	#elif Global.sprite_seleccionado == sprite_anomalia3:
	#	sprite_anomalia3.texture = texturas_anomalia3[randi() % texturas_anomalia3.size()]
	#	sprite_anomalia3.visible = true
	#elif Global.sprite_seleccionado == sprite_anomalianull:
#		sprite_anomalianull.visible = true

# Función para cambiar la textura del fondo actual
func cambiar_fondo_actual():
	background_rect.texture = load(fondos[indice_actual])

	sprite_anomalia1.visible = false
	sprite_anomalia2.visible = false
	sprite_anomalia3.visible = false

	# Solo muestra el sprite seleccionado si corresponde al fondo actual
	if indice_actual == 0 and Global.sprite_seleccionado == sprite_anomalia1:
		sprite_anomalia1.visible = true
	elif indice_actual == 1 and Global.sprite_seleccionado == sprite_anomalia2:
		sprite_anomalia2.visible = true
	elif indice_actual == 2 and Global.sprite_seleccionado == sprite_anomalia3:
		sprite_anomalia3.visible = true

	# Verificar si estamos en la última imagen
	if indice_actual == fondos.size() - 1:
		final_button.visible = true
	else:
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
	if Global.sprite_seleccionado != null:
		# Mueve el sprite al nodo raíz para que no se libere al cambiar de escena
		Global.sprite_seleccionado.get_parent().remove_child(Global.sprite_seleccionado)
		get_tree().root.add_child(Global.sprite_seleccionado)
		
	get_tree().change_scene_to_file("res://scenes/game/nave_puerta_decision.tscn")
	final_button.visible = false
	
func actualizar_texto_dia():
	# Actualiza el texto del Label con el valor del contador global
	label_dia.text = "Día " + str(Global.contador_aciertos)
