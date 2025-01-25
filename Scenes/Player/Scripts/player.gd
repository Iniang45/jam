extends Area2D

class_name Player

@export_range(0.0, 1.0) var accel_factor: float = 0.1
@export_range(0.0, 1.0) var rotation_accel_factor: float = 0.1

@export var max_speed: float = 400.0
@export var fall_speed: float = 500.0  # Gravité vers le bas
@export var max_fall_speed: float = 300.0  # Vitesse maximale de chute
@export var jump_force: float = 400.0  # Force appliquée au saut

@export var barrier_min_x: float = 100.0  # Limite gauche de la barrière
@export var barrier_max_x: float = 900.0  # Limite droite de la barrière
@export var barrier_min_y: float = 0.0  # Limite supérieure de la barrière
@export var barrier_max_y: float = 600.0  # Limite inférieure de la barrière

var speed: float = 10.0
var direction: Vector2 = Vector2.ZERO
var Last_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

# Variable pour savoir si le joueur est au sol
var is_on_ground: bool = false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	check_if_on_ground()
	apply_gravity(delta)
	move(delta)
	clamp_position()  # Appliquer les limites de la barrière

func _input(event: InputEvent) -> void:
	# Obtient le vecteur de direction
	direction = Input.get_vector("Left", "Right", "", "")
	print(direction)
	if direction != Vector2.ZERO:
		Last_direction = direction

	# Gérer le saut
	if Input.is_action_just_pressed("Jump") and is_on_ground:
		jump()

func jump() -> void:
	# Appliquer une force vers le haut pour sauter
	velocity.y = -jump_force
	is_on_ground = false  # Le joueur quitte le sol

func apply_gravity(delta: float) -> void:
	if not is_on_ground:
		# Appliquer la gravité en ajoutant à la vélocité verticale
		velocity.y += fall_speed * delta
		# Limiter la vitesse de chute
		velocity.y = min(velocity.y, max_fall_speed)

func move(delta: float) -> void:
	if direction == Vector2.ZERO:
		speed = lerp(speed, 0.0, accel_factor)  # Diminue la vitesse quand aucune direction
	else:
		speed = lerp(speed, max_speed, accel_factor)  # Accélère progressivement
	
	# Mise à jour de la vélocité horizontale
	velocity.x = Last_direction.x * speed

	# Mise à jour de la position de l'Area2D
	position += velocity * delta

func check_if_on_ground() -> void:
	# Vérifie si le joueur est au sol
	if position.y >= barrier_max_y:
		position.y = barrier_max_y  # Empêche de dépasser la limite
		is_on_ground = true
	else:
		is_on_ground = false

func clamp_position() -> void:
	# Limiter la position du joueur avec clamp
	position.x = clamp(position.x, barrier_min_x, barrier_max_x)
	position.y = clamp(position.y, barrier_min_y, barrier_max_y)
