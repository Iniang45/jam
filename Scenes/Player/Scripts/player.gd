extends CharacterBody2D

class_name Player

@export_range(0.0, 1.0) var accel_factor: float = 0.1
@export_range(0.0, 1.0) var rotation_accel_factor: float = 0.1

@export var max_speed: float = 400.0
@export var fall_speed: float = 800.0  # Gravité vers le bas
@export var max_fall_speed: float = 400.0  # Vitesse maximale de chute
@export var wall_slide_speed: float = 100.0  # Vitesse de glissement le long des murs
@export var jump_force: float = 400.0  # Force appliquée au saut
@export var wall_jump_force: Vector2 = Vector2(300, -350)  # Force appliquée au wall jump

@export var barrier_min_x: float = 40  # Limite gauche de la barrière
@export var barrier_max_x: float = 1100  # Limite droite de la barrière
@export var barrier_min_y: float = 23  # Limite supérieure de la barrière
@export var barrier_max_y: float = 471  # Limite inférieure de la barrière

@export var growth_rate: float = 0.1  # Facteur de croissance
@export var max_scale: float = 2.0  # Taille maximale du joueur
@export var min_speed: float = 100.0  # Vitesse minimale si le joueur devient trop gros

var laPioche = true
var speed: float = 10.0
var direction: Vector2 = Vector2.ZERO
var Last_direction: Vector2 = Vector2.ZERO
var is_stopped: bool = true

signal ilamange 

var is_on_ground: bool = false
var is_on_wall_left: bool = false
var is_on_wall_right: bool = false
var is_on_tree: bool = false
var is_on_bubble: bool = false

@onready var area = $Area2D
@onready var wall_ray_left = $RayCast2D_Left
@onready var wall_ray_right = $RayCast2D_Right

func _ready() -> void:

	$RayCast2D.enabled = true  # Active le RayCast2D
	area.connect("area_entered", Callable(self, "_on_area_entered"))
	area.connect("area_exited", Callable(self, "_on_area_exited"))

	$PlayerSprite.animation = "idle"


func _physics_process(delta: float) -> void:
	check_if_on_ground()
	check_if_on_wall()
	apply_gravity(delta)
	if is_stopped:
		move(delta)
	clamp_position()  # Appliquer les limites de la barrière*
	if is_on_wall():
		print("Collision avec un mur")


func _input(event: InputEvent) -> void:
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	if direction != Vector2.ZERO:
		Last_direction = direction

	if Input.is_action_just_pressed("Jump") and (is_on_wall_left):
		print('sucess')
		wall_jump()
	elif Input.is_action_just_pressed("Jump") and (is_on_wall_right):
		print('sucess')
		wall_jump()
	elif Input.is_action_just_pressed("Jump") and is_on_tree:
		jump()

	elif Input.is_action_just_pressed("Jump") and is_on_ground :
		jump()
	elif Input.is_action_just_pressed("Jump") and is_on_bubble:
		jump()

	if speed > 0 and direction.x == 1:
		$PlayerSprite.animation = "walk"

		
	if speed > 0  and direction[0] == 1 and is_on_ground:
		$PlayerSprite.animation =  "walk"

		$PlayerSprite.play()
	elif speed > 0 and direction.x == -1 and is_on_ground:
		$PlayerSprite.animation = "walk"
		$PlayerSprite.set_flip_h(true)
		$PlayerSprite.play()
	else:
		$PlayerSprite.stop()

	if direction.x == -1:
		$PlayerSprite.set_flip_h(true)
	else:
		$PlayerSprite.set_flip_h(false)

	if check_if_on_ground() and $PlayerSprite.animation == "jump":
		$PlayerSprite.animation = "idle"
		$PlayerSprite.play()





func jump() -> void:
	velocity.y = -jump_force
	is_on_ground = false
	is_on_tree = false
	is_on_bubble = false

func wall_jump() -> void:
	if is_on_wall_left:
		velocity = Vector2(wall_jump_force.x, wall_jump_force.y)
	
	elif is_on_wall_right:
		velocity = Vector2(-wall_jump_force.x, wall_jump_force.y)
	

	is_on_wall_left = false
	is_on_wall_right = false
	move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_ground and not is_on_tree and not is_on_bubble:
		if is_on_wall_left or is_on_wall_right:
			velocity.y = min(velocity.y + fall_speed * delta, wall_slide_speed)
		else:
			velocity.y += fall_speed * delta
			velocity.y = min(velocity.y, max_fall_speed)

func move(delta: float) -> void:
	if direction == Vector2.ZERO:
		speed = lerp(speed, 0.0, accel_factor)
	else:
		speed = lerp(speed, max_speed, accel_factor)

	velocity.x = Last_direction.x * speed
	move_and_slide()

func check_if_on_ground():
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		print("RayCast collision avec :", collider)
		if collider and collider.is_in_group("ArbreMagique"):  # Vérifie le groupe
			is_on_tree = true
			return false
		if collider and collider.is_in_group("bubbles"):  # Vérifie le groupe
			is_on_bubble = true
			return false
	is_on_tree = false
	is_on_bubble = false
	is_on_ground = position.y >= barrier_max_y
	return is_on_ground

func check_if_on_wall():
	is_on_wall_left = is_on_wall()
	is_on_wall_right = is_on_wall()

func clamp_position() -> void:
	position.x = clamp(position.x, barrier_min_x, barrier_max_x)
	position.y = clamp(position.y, barrier_min_y, barrier_max_y)





func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("ArbreMagique"):
		is_on_tree = true
	if area.is_in_group("bubbles"):
		is_on_bubble = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("ArbreMagique"):
		is_on_tree = false
	if area.is_in_group("bubbles"):
		is_on_bubble = false






func _on_arbre_magique_area_entered(area: Area2D) -> void:
	is_stopped = false  # Bloque le joueur
	print("Est bloquer")
	


func _on_arbre_magique_area_exited(area: Area2D) -> void:
	is_stopped = true #Debloque joueur
	print("Est bloquer NON")


func _on_grosluffy_area_entered(area: Area2D) -> void:
	print("Le joueur mange un gâteau !")
	$PlayerSprite.animation = "gros"
	$PlayerSprite.play()
	ilamange.emit()
	
