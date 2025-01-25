@tool
extends Area2D

enum SIZE {
	SEED,
	SMALL,
	MEDIUM,
	BIG
}

@onready var sprite: Sprite2D = $ArbreSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var Arbre_Size_array: Array[ArbreSize]
@export var size: SIZE = SIZE.SEED  # Taille par défaut à SEED

signal size_changed

func _ready() -> void:
	size_changed.connect(update_size)
	update_size()

func set_size(value: SIZE) -> void:
	if value != size:
		size = value
		emit_signal("size_changed")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("use"):  # Par exemple, "use" est une action mappée dans ton Input Map.
		# Passe à la taille suivante
		size = int(size) + 1  # Incrémentation de la taille
		if size >= SIZE.values().size():  # Si on dépasse la dernière taille
			size = SIZE.SEED  # Reviens à SEED
		emit_signal("size_changed")

func update_size() -> void:
	# Récupère l'objet ArbreSize correspondant à la taille actuelle
	var arbre_size = Arbre_Size_array[int(size)]
	sprite.texture = arbre_size.texture
	collision_shape.shape = arbre_size.shape  # Vérifie que cette propriété existe dans ArbreSize
