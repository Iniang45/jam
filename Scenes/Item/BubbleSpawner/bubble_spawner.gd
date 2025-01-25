extends Node2D

@export var bubble_scene: PackedScene  # Préfabriqué de bulle à instancier
@export var spawn_positions: Array = [
	Vector2(100, 100),  # Premier point de spawn
	Vector2(500, 100),  # Deuxième point de spawn
	Vector2(300, 200)   # Troisième point de spawn
]  # Liste des points de spawn
@export var bubbles_per_point: int = 1  # Nombre de bulles à générer par point
@export var horizontal_variation: float = 50.0  # Amplitude aléatoire pour les vitesses horizontales
@export var min_bubble_size: float = 0.5  # Taille minimale des bulles
@export var max_bubble_size: float = 1.0  # Taille maximale des bulles

func _ready():
	$Timer.start()
	$Timer.connect("timeout", Callable(self, "_spawn_bubbles"))

func _spawn_bubbles():
	# Parcourir tous les points de spawn
	for spawn_position in spawn_positions:
		# Générer plusieurs bulles par point de spawn
		for i in range(bubbles_per_point):
			var bubble = bubble_scene.instantiate()
			add_child(bubble)

			# Définir un angle aléatoire
			bubble.angle_offset = randf_range(-15.0, 15.0)

			# Ajouter une variation horizontale
			var random_horizontal_speed = randf_range(-horizontal_variation, horizontal_variation)
			bubble.horizontal_speed += random_horizontal_speed

			# Définir une taille aléatoire pour la bulle
			var random_scale = randf_range(min_bubble_size, max_bubble_size)
			bubble.scale = Vector2(random_scale, random_scale)

			# Positionner la bulle au point de spawn actuel
			bubble.position = spawn_position

			# Connecter le signal tree_exited
			bubble.connect("tree_exited", Callable(self, "_on_bubble_exited").bind(bubble))
			bubble.add_to_group("bubbles")

func _on_bubble_exited(bubble):
	bubble.queue_free()
