extends Control

@onready var background_rect = $BackgroundRect
@onready var puerta_rect = $PuertaTextureRect
@onready var label_dia = $LabelDia 
@onready var final_button = $FinalButton  
@onready var sprite_p1_tablero_anomalia = $SpriteP1Tablero
@onready var sprite_p1_silla_anomalia = $SpriteP1Silla
@onready var sprite_p2_vitrina_anomalia = $SpriteP2Vitrina
@onready var sprite_p2_planta_anomalia = $SpriteP2Planta
@onready var sprite_p3_mesa_anomalia = $SpriteP3Mesa
@onready var sprite_p3_almohada_anomalia = $SpriteP3Almohada
@onready var sprite_anomalianull = $SpriteAnomalianull

###Manejo de sprites
var sprite_seleccionado = null  # Referencia al sprite que se hará visible
var ultimo_sprite = null  # Almacena el último sprite seleccionado para evitar repeticiones

# Índice del fondo actual
var indice_actual = 0  

### Declaracion de fondos
var fondos = [
	"res://assets/images/sala_de_comando_scene/screen.png",
	"res://assets/images/vitrina_scene/screen.png",
	"res://assets/images/puerta_scene/screen.png"
]

### Declaración de texturas
#sala de comando
var texturas_silla = [load("res://assets/images/sala_de_comando_scene/anomalias/p1_silla_1.png")]
var texturas_tablero = [load("res://assets/images/sala_de_comando_scene/anomalias/p1_tablero_0.png"), load("res://assets/images/sala_de_comando_scene/anomalias/p1_tablero_1.png")]
#vitrina
var texturas_planta = [load("res://assets/images/vitrina_scene/anomalias/p2_planta_0.png"),load("res://assets/images/vitrina_scene/anomalias/p2_planta_1.png")]
var texturas_vitrina = [load("res://assets/images/vitrina_scene/anomalias/p2_vitrina_1.png")]
#puerta
var texturas_almohada = [load("res://assets/images/puerta_scene/anomalias/p3_almohada_0.png"),load("res://assets/images/puerta_scene/anomalias/p3_almohada_1.png"),]
var texturas_mesa = [load("res://assets/images/puerta_scene/anomalias/p3_mesa_0.png"),load("res://assets/images/puerta_scene/anomalias/p3_mesa_1.png"),]


# Declaración de mapas
var sprite_texturas_map = {
	sprite_p1_silla_anomalia: texturas_silla,
	sprite_p1_tablero_anomalia: texturas_tablero,
	sprite_p2_vitrina_anomalia: texturas_vitrina,
	sprite_p2_planta_anomalia: texturas_planta,
	sprite_p3_almohada_anomalia: texturas_almohada,
	sprite_p3_mesa_anomalia: texturas_mesa,
	sprite_anomalianull: []
}

var fondo_sprite_map = {}
var opciones = []

func _ready():
	var global_audio_manager = get_node("/root/GlobalAudioManager")
	if global_audio_manager:
		global_audio_manager.start_game_music()
		
	init_mapa_de_fondos()
	ocultar_todas_las_anomalias()
	Global.sprite_clickeado = false  # Resetea la variable al iniciar la escena
	Global.sprite_anomalianull = sprite_anomalianull
	
	if Global.contador_aciertos == 0:
		Global.sprite_seleccionado = null

	if Global.contador_aciertos < Global.dias_por_sobrevivir + 1:
		seleccionar_sprite_aleatorio()
		cargar_textura_fondo()
		actualizar_texto_dia()


# #####################################################SelecciónDelScriptDeAcuerdo al sprite global

# Función para seleccionar aleatoriamente un sprite y una textura
func seleccionar_sprite_aleatorio():
	if Global.contador_aciertos > 0:
		print("> ULTIMO SPRITE", ultimo_sprite)
		opciones = [sprite_anomalianull, sprite_p1_tablero_anomalia, sprite_p1_silla_anomalia, sprite_p2_vitrina_anomalia,  sprite_p2_planta_anomalia, sprite_p3_mesa_anomalia, sprite_p3_almohada_anomalia]
		var nuevas_opciones = opciones.filter(func(opcion):
			return opcion != ultimo_sprite
		)

		if nuevas_opciones.size() > 0:
			Global.sprite_seleccionado = nuevas_opciones[randi() % nuevas_opciones.size()]
			seleccionar_sprite_y_textura(Global.sprite_seleccionado)
		else:
			ultimo_sprite = Global.sprite_seleccionado
			Global.sprite_seleccionado = sprite_seleccionado
			ocultar_todas_las_anomalias()
		print("el sprite seleccionado es ...", Global.sprite_seleccionado)

# Función para cambiar la textura del fondo actual
func cargar_textura_fondo():
	ocultar_todas_las_anomalias()
	background_rect.texture = load(fondos[indice_actual])
	
	# Solo muestra el sprite seleccionado si corresponde al fondo actual
	if fondo_sprite_map.has(indice_actual):
		for sprite in fondo_sprite_map[indice_actual]:
			if Global.sprite_seleccionado:
				if sprite == Global.sprite_seleccionado:
					sprite.visible = true
					break
	handle_ultimo_panel()
	
func actualizar_texto_dia():
	# Actualiza el texto del Label con el valor del contador global
	label_dia.text = "Día " + str(Global.contador_aciertos)


## Helpers
func init_mapa_de_fondos():
	fondo_sprite_map = {
		0: [sprite_p1_tablero_anomalia, sprite_p1_silla_anomalia],
		1: [sprite_p2_vitrina_anomalia, sprite_p2_planta_anomalia],
		2: [sprite_p3_mesa_anomalia, sprite_p3_almohada_anomalia]
	}
	
func seleccionar_sprite_y_textura(sprite):
	var texturas = sprite_texturas_map.get(sprite, [])
	if texturas.size() > 0:
		sprite.texture = texturas[randi() % texturas.size()]
	sprite.visible = true

# Ocultar todas las anomalias
func ocultar_todas_las_anomalias():
	for sprite in opciones:
		sprite.visible = false

# Verificar si estamos en el ultimo panel
func handle_ultimo_panel():
	if indice_actual == fondos.size() - 1:
		puerta_rect.visible = true
		final_button.visible = true
	else:
		puerta_rect.visible = false
		final_button.visible = false
		
		
func navegar_paneles(delta):
	indice_actual += delta
	if indice_actual >= fondos.size():
		indice_actual = 0
	elif indice_actual < 0:
		indice_actual = fondos.size() - 1
	cargar_textura_fondo()
	
### Funciones de los botones
func _on_button_siguiente_pressed():
	navegar_paneles(1)

func _on_button_anterior_pressed():
	navegar_paneles(-1)
	
func _on_final_button_pressed():
	puerta_rect.visible = false
	
	# Mueve el sprite al nodo raíz para que no se libere al cambiar de escena
	if Global.sprite_seleccionado != null:
		Global.sprite_seleccionado.get_parent().remove_child(Global.sprite_seleccionado)
		get_tree().root.add_child(Global.sprite_seleccionado)
	
	background_rect.texture = null
	get_tree().change_scene_to_file("res://scenes/game/nave_puerta_decision.tscn")
	final_button.visible = false

### TO DO:
#1. Aparecer modal con opciones..
#2. Si hace click en quedarse a descansar.... mostrar sala de comando, anomalia no debe estar en el 1er cuadro
