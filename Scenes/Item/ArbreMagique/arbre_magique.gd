extends StaticBody2D

enum SIZE {
	SEED,
	SMALL,
	MEDIUM,
	BIG
}

@onready var sprites = {
	SIZE.SEED: $Sprite_SEED,
	SIZE.SMALL: $Sprite_SMALL,
	SIZE.MEDIUM: $Sprite_MEDIUM,
	SIZE.BIG: $Sprite_BIG
}

@onready var collision_shapes = {
	SIZE.SEED: $CollisionShape_SEED,
	SIZE.SMALL: $CollisionShape_SMALL,
	SIZE.MEDIUM: $CollisionShape_MEDIUM,
	SIZE.BIG: $CollisionShape_BIG
}

@export var size: SIZE = SIZE.SEED  # Taille actuelle de l'arbre

func _ready() -> void:
	update_visuals_and_collision()

# Appelé chaque fois que la taille de l'arbre change
func update_visuals_and_collision() -> void:
	# Désactiver tous les sprites et collisions
	for sprite in sprites.values():
		sprite.visible = false
	for shape in collision_shapes.values():
		shape.disabled = true

	# Activer le sprite et la collision correspondant à la taille actuelle
	sprites[size].visible = true
	collision_shapes[size].disabled = false

# Exemple pour changer de taille avec une entrée utilisateur
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("use"):  # Exemple : touche pour changer de taille
		size = (size + 1) % SIZE.values().size()  # Passer à la taille suivante
		update_visuals_and_collision()
