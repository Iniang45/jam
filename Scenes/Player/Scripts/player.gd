extends Area2D

class_name Player

@export_range(0.0, 1.0) var accel_factor: float = 0.1
@export_range(0.0, 1.0) var rotation_accel_factor: float = 0.1

@export var max_speed: float = 400.0
@export var fall_speed: float = 500.0  # Gravité vers le bas
@export var max_fall_speed: float = 300.0  # Vitesse maximale de chute
@export var jump_force: float = 400.0  # Force appliquée au saut
# @export var climb_speed: float = 200.0 # Vitesse d'escalade

@export var barrier_min_x: float = 100.0  # Limite gauche de la barrière
@export var barrier_max_x: float = 900.0  # Limite droite de la barrière
@export var barrier_min_y: float = 0.0  # Limite supérieure de la barrière
@export var barrier_max_y: float = 600.0  # Limite inférieure de la barrière

var speed: float = 10.0
var direction: Vector2 = Vector2.ZERO
var Last_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

# Variable pour savoir si le joueur est au sol ou contre un mur
var is_on_ground: bool = false
var is_on_wall: bool = false

func _ready() -> void:
	pass

const wall_jump_pushback = 100

func _physics_process(delta: float) -> void:
	check_if_on_ground()
	check_if_on_wall()
	apply_gravity(delta)
	move(delta)
	clamp_position()  # Appliquer les limites de la barrière

func _input(event: InputEvent) -> void:
	# Obtient le vecteur de direction
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	print(direction)
	if direction != Vector2.ZERO:
		Last_direction = direction

	# Gérer le saut
	if Input.is_action_just_pressed("Jump") and is_on_ground:
		jump()

func jump() -> void:
	# Appliquer une force vers le haut pour sauter
	velocity.y = -jump_force
	if Input.is_action_just_pressed("Jump"):
		if check_if_on_ground():
			velocity.y = jump_force
		if check_if_on_wall() and Input.is_action_just_pressed("Right"):
			velocity.y = jump_force
			velocity.x = -wall_jump_pushback
		if check_if_on_wall() and Input.is_action_just_pressed("Left"):
			velocity.y = jump_force
			velocity.x = wall_jump_pushback
		
	# is_on_ground = false  # Le joueur quitte le sol

func apply_gravity(delta: float) -> void:
	if not is_on_ground: # and not is_on_ladder:
		# Appliquer la gravité en ajoutant à la vélocité verticale
		velocity.y += fall_speed * delta
		# Limiter la vitesse de chute
		velocity.y = min(velocity.y, max_fall_speed)
	# elif is_on_ladder and direction.y < 0: # Si on est en train d'escalader
		# velocity.y = -climb_speed

func move(delta: float) -> void:
	if direction == Vector2.ZERO:
		speed = lerp(speed, 0.0, accel_factor)  # Diminue la vitesse quand aucune direction
	else:
		speed = lerp(speed, max_speed, accel_factor)  # Accélère progressivement
	
	# Mise à jour de la vélocité horizontale
	velocity.x = Last_direction.x * speed
	
	# Si le joueur est contre un mur et appuie sur la touche pour avancer : le fait grimper
	# if is_on_ladder and direction.y > 0:
		# velocity.y = climb_speed # Grimpe si on appuie vers le haut

	# Mise à jour de la position de l'Area2D
	position += velocity * delta

func check_if_on_ground():
	# Vérifie si le joueur est au sol
	if position.y >= barrier_max_y:
		position.y = barrier_max_y  # Empêche de dépasser la limite
		is_on_ground = true
	else:
		is_on_ground = false

func check_if_on_wall():
	# Vérifie si le joueur est contre un mur 
	is_on_wall = false
	if position.x <= barrier_min_x or position.x >= barrier_max_x:
		is_on_wall = true

func clamp_position() -> void:
	# Limiter la position du joueur avec clamp
	position.x = clamp(position.x, barrier_min_x, barrier_max_x)
	position.y = clamp(position.y, barrier_min_y, barrier_max_y)
		
