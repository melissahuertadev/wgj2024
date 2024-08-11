extends Control

# Array con las rutas de las escenas
var escenas = [
	"res://Escenas/escena1.tscn",
	"res://Escenas/escena2.tscn",
	"res://Escenas/escena3.tscn",
	"res://Escenas/escena4.tscn"
]

var indice_actual = 0  # Índice de la escena actual

func _ready():
	cargar_escena_actual()

# Función para cargar la escena actual
func cargar_escena_actual():
	var nueva_escena = load(escenas[indice_actual]).instantiate()
	get_parent().add_child(nueva_escena)
	# O si prefieres, añadir al mismo nodo que maneja el script:
	# add_child(nueva_escena)
	
	# Asegurarse de que solo haya una escena cargada a la vez
	for child in get_parent().get_children():
		if child != self and child != nueva_escena:
			child.queue_free()

# Función para manejar el botón "Siguiente"
func _on_button_siguiente_pressed():
	indice_actual += 1
	if indice_actual >= escenas.size():
		indice_actual = 0  # Reinicia al principio si pasa el último
	cargar_escena_actual()

# Función para manejar el botón "Anterior"
func _on_button_anterior_pressed():
	indice_actual -= 1
	if indice_actual < 0:
		indice_actual = escenas.size() - 1  # Va al final si pasa el primero
	cargar_escena_actual()
