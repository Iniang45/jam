extends Area2D

@export var angle_offset: float = 0.0  # Inclinaison (en degrés)
@export var vertical_speed: float = 100.0  # Vitesse verticale
@export var oscillation_speed: float = 2.0  # Vitesse d'oscillation (Hz)
@export var oscillation_distance: float = 50.0  # Distance d'oscillation
@export var horizontal_speed: float = 0.0  # Vitesse horizontale de base

var time_passed: float = 0.0

func _ready():
	# Convertir l'angle en vitesse horizontale
	horizontal_speed += tan(deg_to_rad(angle_offset)) * vertical_speed
	time_passed = 0.0
	print("Bubble ready with angle_offset =", angle_offset, "and horizontal_speed =", horizontal_speed)  # Debug

func _process(delta):
	# Ajoutez du temps pour les oscillations
	time_passed += delta

	# Oscillation horizontale (effet flottant)
	var oscillation_offset = sin(time_passed * oscillation_speed * PI * 2) * oscillation_distance

	# Déplacement horizontal (influence de l'angle et oscillation)
	position.x += horizontal_speed * delta + oscillation_offset * delta

	# Déplacement vertical
	position.y -= vertical_speed * delta

	# Supprimer si la bulle sort de l'écran
	if position.y < -get_viewport_rect().size.y or position.x < 0 or position.x > get_viewport_rect().size.x:
		queue_free()
