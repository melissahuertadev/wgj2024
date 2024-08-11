extends Control
@onready var story_animation_player : AnimationPlayer = $StoryAnimation
@onready var story_rich_text_label : RichTextLabel = $Story
@onready var continuar_button : Button = $BotonContinuar

# Duración total de la intro en segundos
@export var intro_duration : float = 15.0
# Tiempo de retraso para mostrar el botón en segundos
@export var button_delay : float = 2.0

var story_texts : Array = [
	"Todo comenzó a las 08:00 AM.\n\nPartí en busca del \"Lirio de la Paz\", una planta que me ayudaría con la producción de oxígeno a gran escala. Un error en las coordenadas me llevó a un [color=#ffbf00]agujero negro[/color] que absorbió mi nave. Ahora estoy atrapada, y el [color=#ffbf00]día parece repetirse[/color] sin fin.\n\nMe di cuenta de algo inquietante: [color=#ffbf00]la fecha no cambiaba, mientras que otros aspectos del entorno sí[/color]. Cada intento de escapar parece enredarme aún más en este ciclo interminable...",
	"[color=#d2b1ea]MISIÓN:[/color] Debo sobrevivir 3 días sin que la anomalía reinicie el día.\n\n[color=#d2b1ea]INSTRUCCIONES[/color]: Necesito identificar si hay alguna distorsión en la sala de comandos.\n
	> Si no encuentro nada, debo descansar aquí.
	> Si encuentro algo diferente, debo salir de la sala.
	\nDe lo contrario, mi día se reiniciará...
	Debo encontrar una manera de escapar de este bucle..."
]
var current_text_index : int = 0

func _ready():
	# Reproduce la animación y establece el primer texto
	story_animation_player.play("story_animation")
	$ListaBitacoras.text = "Bitacora#122\nBitacora#123"
	$BitacoraActual.text= "Bitacora#871\n\nFecha: 08/08/4042"
	
	# Inicialmente oculta el botón de continuar
	continuar_button.visible = false
	
	# Muestra el primer texto
	story_rich_text_label.text = story_texts[current_text_index]
	
	# Conecta la señal de pulsación del botón
	continuar_button.pressed.connect(_on_Continuar_pressed)

	# Configura el temporizador para mostrar el botón
	show_button_after_delay()

# Función que se llama cuando el botón "CONTINUAR" es presionado
func _on_Continuar_pressed():
	# Mueve al siguiente texto y maneja la visibilidad del botón
	current_text_index += 1
	
	if current_text_index < story_texts.size():
		# Cambia el texto y oculta el botón
		if story_rich_text_label:
			story_rich_text_label.text = story_texts[current_text_index]
		continuar_button.visible = false
		
		# Muestra el botón después de un retraso
		show_button_after_delay()
	else:
		# Todos los textos han sido mostrados, cambia de escena
		get_tree().change_scene_to_file("res://escenaprincipal.tscn")

# Crea y configura un nuevo temporizador
func show_button_after_delay():
	var timer = Timer.new()
	timer.wait_time = button_delay
	timer.one_shot = true
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(_on_Timer_timeout)

func _on_Timer_timeout():
	continuar_button.visible = true
