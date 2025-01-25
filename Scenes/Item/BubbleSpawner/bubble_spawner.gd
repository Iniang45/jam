extends Node2D

@export var bubble_scene: PackedScene  # Préfabriqué de bulle à instancier
@export var spawn_position: Vector2 = Vector2(100, 100)  # Position fixe pour le spawn des bulles
@export var bubble_count: int = 1  # Nombre de bulles à générer en même temps
@export var horizontal_variation: float = 50.0  # Amplitude aléatoire pour les vitesses horizontales

func _ready():
	$Timer.start()
	$Timer.connect("timeout", Callable(self, "_spawn_bubbles"))

func _spawn_bubbles():
	for i in range(bubble_count):
		var bubble = bubble_scene.instantiate()
		add_child(bubble)

		# Définir un angle aléatoire
		bubble.angle_offset = randf_range(-15.0, 15.0)

		# Ajouter une variation horizontale
		var random_horizontal_speed = randf_range(-horizontal_variation, horizontal_variation)
		bubble.horizontal_speed += random_horizontal_speed  # Ajouter une vitesse horizontale unique
		
		bubble.position = spawn_position

		# Connecter le signal tree_exited
		bubble.connect("tree_exited", Callable(self, "_on_bubble_exited").bind(bubble))

func _on_bubble_exited(bubble):
	bubble.queue_free()
