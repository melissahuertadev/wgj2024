extends Control

# Array con las rutas de las texturas
var fondos = [
	"res://fondos/fondo1.png",
	"res://fondos/fondo2.png",
	"res://fondos/fondo3.png"
]

var indice_actual = 0  # Índice del fondo actual
var simultaneous_scene = preload("res://Escenas/escenapuerta.tscn").instantiate()

# Referencia al TextureRect que mostrará los fondos
@onready var background_rect = $BackgroundRect
@onready var final_button = $FinalButton  # Asegúrate de que el nombre coincida
#sprite anomalias
@onready var sprite_anomalia1 = $SpriteAnomalia1
@onready var sprite_anomalia2 = $SpriteAnomalia2
@onready var sprite_anomalia3 = $SpriteAnomalia3

# Arrays de texturas para los sprites
var texturas_anomalia1 = [
	load("res://Anomalias/anomalia1.png"),
	load("res://Anomalias/anomalia11.png")
]

var texturas_anomalia2 = [
	load("res://Anomalias/anomalia2.png"),
	load("res://Anomalias/anomalia22.png")
]

var texturas_anomalia3 = [
	load("res://Anomalias/anomalia3.png"),
	load("res://Anomalias/anomalia33.png")
]

var contador = 0  # Contador para los clics en los sprites
var sprite_seleccionado = null  # Referencia al sprite que se hará visible
var ultimo_sprite = null  # Almacena el último sprite seleccionado para evitar repeticiones

func _ready():
	seleccionar_sprite_aleatorio()
	cambiar_fondo_actual()

# Función para seleccionar aleatoriamente un sprite y una textura
func seleccionar_sprite_aleatorio():
	var opciones = [null, sprite_anomalia1, sprite_anomalia2, sprite_anomalia3]
	var nuevas_opciones = opciones.filter(func(opcion):
		return opcion != ultimo_sprite
	)

	# Seleccionar un nuevo sprite que no sea el anterior
	if nuevas_opciones.size() > 0:
		sprite_seleccionado = nuevas_opciones[randi() % nuevas_opciones.size()]
	else:
		sprite_seleccionado = null  # En caso de que por alguna razón no haya opciones

	# Actualizar el último sprite seleccionado
	ultimo_sprite = sprite_seleccionado

	# Asegúrate de que solo el sprite seleccionado es visible
	sprite_anomalia1.visible = false
	sprite_anomalia2.visible = false
	sprite_anomalia3.visible = false

	# Seleccionar aleatoriamente una textura para el sprite seleccionado
	if sprite_seleccionado == sprite_anomalia1:
		sprite_anomalia1.texture = texturas_anomalia1[randi() % texturas_anomalia1.size()]
		sprite_anomalia1.visible = true
	elif sprite_seleccionado == sprite_anomalia2:
		sprite_anomalia2.texture = texturas_anomalia2[randi() % texturas_anomalia2.size()]
		sprite_anomalia2.visible = true
	elif sprite_seleccionado == sprite_anomalia3:
		sprite_anomalia3.texture = texturas_anomalia3[randi() % texturas_anomalia3.size()]
		sprite_anomalia3.visible = true

# Función para cambiar la textura del fondo actual
func cambiar_fondo_actual():
	background_rect.texture = load(fondos[indice_actual])

	# Oculta todos los sprites al cambiar de fondo
	sprite_anomalia1.visible = false
	sprite_anomalia2.visible = false
	sprite_anomalia3.visible = false

	# Solo muestra el sprite seleccionado si corresponde al fondo actual
	if indice_actual == 0 and sprite_seleccionado == sprite_anomalia1:
		sprite_anomalia1.visible = true
	elif indice_actual == 1 and sprite_seleccionado == sprite_anomalia2:
		sprite_anomalia2.visible = true
	elif indice_actual == 2 and sprite_seleccionado == sprite_anomalia3:
		sprite_anomalia3.visible = true

	# Verificar si estamos en la última imagen
	if indice_actual == fondos.size() - 1:
		final_button.visible = true  # Mostrar el botón
	else:
		final_button.visible = false  # Ocultar el botón
	
# Función para manejar el botón "Siguiente"
func _on_button_siguiente_pressed():
	indice_actual += 1
	if indice_actual >= fondos.size():
		indice_actual = 0  # Reinicia al principio si pasa el último
	cambiar_fondo_actual()

# Función para manejar el botón "Anterior"
func _on_button_anterior_pressed():
	indice_actual -= 1
	if indice_actual < 0:
		indice_actual = fondos.size() - 1  # Va al final si pasa el primero
	cambiar_fondo_actual()
	
# Botón para la puerta
func _on_final_button_pressed():
	#get_tree().change_scene("res://Escenas/escena1.tscn")
	get_tree().root.add_child(simultaneous_scene)
