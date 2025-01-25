extends Area2D


class_name Player

@export_range(0.0, 1.0) var accel_factor: float = 0.1
@export_range(0.0, 1.0) var rotation_accel_factor: float = 0.1

@export var max_speed: float = 400.0
@export var fall_speed: float = 800.0  # Gravité vers le bas
@export var max_fall_speed: float = 400.0  # Vitesse maximale de chute
@export var wall_slide_speed: float = 100.0 # Vitesse de glissement le long des murs
@export var jump_force: float = 400.0  # Force appliquée au saut
@export var wall_jump_force: Vector2 = Vector2(300, -350) # Force appliquée au wall jump

@export var barrier_min_x: float = 0  # Limite gauche de la barrière
@export var barrier_max_x: float = 1152  # Limite droite de la barrière
@export var barrier_min_y: float = 0.0  # Limite supérieure de la barrière
@export var barrier_max_y: float = 648  # Limite inférieure de la barrière

@export var growth_rate: float = 0.1  # Facteur de croissance
@export var max_scale: float = 2.0  # Taille maximale du joueur
@export var min_speed: float = 100.0  # Vitesse minimale si le joueur devient trop gros
var laPioche = true
var speed: float = 10.0
var direction: Vector2 = Vector2.ZERO
var Last_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var is_stopped: bool = true

# Variable pour savoir si le joueur est au sol ou contre un mur
var is_on_ground: bool = false
var is_on_wall_left: bool = false
var is_on_wall_right: bool = false

var current_direction: int = 0  # Indice de la direction sélectionnée
var stick_instance: Area2D = null  # Référence à la ventouse active (si existante)

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	check_if_on_ground()
	check_if_on_wall()
	apply_gravity(delta)
	if is_stopped  :
		move(delta)
	clamp_position()  # Appliquer les limites de la barrière

func _input(event: InputEvent) -> void:
	# Obtient le vecteur de direction
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	print(direction)
	if direction != Vector2.ZERO:
		Last_direction = direction

		# Déclenche un wall jump si le joueur est sur un mur 
	if Input.is_action_just_pressed("Jump") and (is_on_wall_left or is_on_wall_right):
		wall_jump()
	elif Input.is_action_just_pressed("Jump") and is_on_ground:
		jump()
		
	if speed > 0  and direction[0] == 1 and is_on_ground:
		$PlayerSprite.animation =  "walk"
		$PlayerSprite.play()
	elif  speed > 0  and direction[0] == -1 and is_on_ground:
		$PlayerSprite.animation =  "walk"
		$PlayerSprite.set_flip_h(true)
		$PlayerSprite.play()
	else:
		$PlayerSprite.stop()
		
	if direction[0]== -1:
		$PlayerSprite.set_flip_h(true)
	else:
		$PlayerSprite.set_flip_h(false)

	
	if check_if_on_ground() and $PlayerSprite.animation == "jump":
		$PlayerSprite.animation = "idle"
		$PlayerSprite.play()


<<<<<<< HEAD
=======


>>>>>>> ba474ea9f20787114f05a59fff582a8ca5f31c77

func jump() -> void:
	# Appliquer une force vers le haut pour sauter
	velocity.y = -jump_force
	is_on_ground = false  # Le joueur quitte le sol

func wall_jump() -> void:
	#Appliquer une force de saut directionnelle en fonction du mur
	if is_on_wall_left:
		velocity = Vector2(wall_jump_force.x, wall_jump_force.y) # saut vers la droite
	elif is_on_wall_right:
		velocity = Vector2(-wall_jump_force.x, wall_jump_force.y) # saut vers la droite
	
	#Libérer le mur pour permettre au joueur de partir 
	is_on_wall_left = false
	is_on_wall_right = false

func apply_gravity(delta: float) -> void:
	if not is_on_ground: # and not is_on_ladder:
		if is_on_wall_left or is_on_wall_right:
			# on limite la vitesse de chute
			velocity.y = min(velocity.y + fall_speed*delta, wall_slide_speed)
		else:
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

func check_if_on_ground():
	# Vérifie si le joueur est au sol
	if position.y >= barrier_max_y:
		position.y = barrier_max_y  # Empêche de dépasser la limite
		is_on_ground = true
	else:
		is_on_ground = false

func check_if_on_wall():
	is_on_wall_left = position.x <= barrier_min_x
	is_on_wall_right = position.x >= barrier_max_x
	# Assurez-vous que la détection de mur ne reste pas activée en cas de collision avec l'arbre
	if is_stopped:
		is_on_wall_left = false
		is_on_wall_right = false
	# Si le joueur est au sol, il ne peut pas être en même temps sur un mur 
	if is_on_ground:
		is_on_wall_left = false
		is_on_wall_right = false

func clamp_position() -> void:
	# Limiter la position du joueur avec clamp
	position.x = clamp(position.x, barrier_min_x, barrier_max_x)
	position.y = clamp(position.y, barrier_min_y, barrier_max_y)




func _on_grosluffy_area_entered(area: Area2D) -> void:
	print("Le joueur mange un gâteau !")






func _on_arbre_magique_area_entered(area: Area2D) -> void:
	is_stopped = false  # Bloque le joueur
	print("Est bloquer")
	


func _on_arbre_magique_area_exited(area: Area2D) -> void:
	is_stopped = true #Debloque joueur
	print("Est bloquer NON")
