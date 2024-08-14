extends Control

@onready var start_button : Button = $Inicio
@onready var options_button : Button = $Opciones
@onready var quit_button : Button = $Quit

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://game_intro.tscn")

func _on_options_button_pressed():
	# Anular el volumen del juego
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)

func _on_quit_button_pressed():
	get_tree().quit()
