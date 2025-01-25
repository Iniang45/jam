@tool
extends Area2D

enum SIZE {
	SMALL,
	MEDIUM,
	BIG
}

@onready var sprite: Sprite2D = $ArbreSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var Arbre_Size_array: Array[ArbreSize]
@export var size: SIZE = SIZE.BIG  # Correction ici

signal size_changed

func _ready() -> void:
	if Engine.is_editor_hint():
		set_physics_process(false)
	else:
		set_physics_process(true)
	size_changed.connect(update_size)
	update_size()

func set_size(value: SIZE) -> void:
	if value != size:
		size = value
		emit_signal("size_changed")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Jump") and (is_on_wall_left or is_on_wall_right):
	if event is InputEventMouseButton and event.button_index == MouseButton.LEFT and event.pressed:
		# Passe à la taille suivante
		size = SIZE((size + 1) % SIZE.values().size())
		emit_signal("size_changed")

func update_size() -> void:
	var arbre_size = Arbre_Size_array[size]
	sprite.texture = arbre_size.texture
	collision_shape.shape = arbre_size.shape
