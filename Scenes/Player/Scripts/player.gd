extends Area2D

class_name Player

@export_range(0.0, 1.0) var accel_factor: float = 0.1
@export_range(0.0, 1.0) var rotation_accel_factor: float = 0.1

@export var max_speed: float = 400.0
@export var fall_speed: float = 500.0
@export var max_fall_speed: float = 300.0
@export var jump_force: float = 400.0

@export var barrier_min_x: float = 100.0
@export var barrier_max_x: float = 900.0
@export var barrier_min_y: float = 0.0
@export var barrier_max_y: float = 600.0

var speed: float = 10.0
var direction: Vector2 = Vector2.ZERO
var Last_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var is_on_ground: bool = false

# RayCast pour détecter les murs
@onready var raycast_left = $RayCast2D_Left
@onready var raycast_right = $RayCast2D_Right

func _ready() -> void:
	raycast_left.enabled = true
	raycast_right.enabled = true

func _physics_process(delta: float) -> void:
	check_if_on_ground()
	apply_gravity(delta)
	detect_wall_and_climb(delta)  # Détecte les murs et grimpe
	move(delta)
	clamp_position()

func _input(event: InputEvent) -> void:
	direction = Input.get_vector("Left", "Right", "", "")
	if direction != Vector2.ZERO:
		Last_direction = direction

	if Input.is_action_just_pressed("Jump") and is_on_ground:
		jump()

func jump() -> void:
	velocity.y = -jump_force
	is_on_ground = false

func apply_gravity(delta: float) -> void:
	if not is_on_ground:
		velocity.y += fall_speed * delta
		velocity.y = min(velocity.y, max_fall_speed)

func detect_wall_and_climb(delta: float) -> void:
	# Vérifie si un mur est détecté à gauche ou à droite
	if raycast_left.is_colliding() or raycast_right.is_colliding():
		# Appliquer un mouvement vertical continu pour "grimper"
		velocity.y = 100.0  # Ajustez cette valeur pour contrôler la vitesse d'escalade
		position.y += velocity.y * delta

func move(delta: float) -> void:
	if direction == Vector2.ZERO:
		speed = lerp(speed, 0.0, accel_factor)
	else:
		speed = lerp(speed, max_speed, accel_factor)
	velocity.x = Last_direction.x * speed
	position += velocity * delta

func check_if_on_ground() -> void:
	if position.y >= barrier_max_y:
		position.y = barrier_max_y
		is_on_ground = true
	else:
		is_on_ground = false

func clamp_position() -> void:
	position.x = clamp(position.x, barrier_min_x, barrier_max_x)
	position.y = clamp(position.y, barrier_min_y, barrier_max_y)
