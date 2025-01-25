extends Area2D

@export var shoot_speed: float = 1000.0  # Vitesse de tir du bâton
@export var platform_scene: PackedScene  # Scène de la plateforme (bâton) une fois attachée

var velocity: Vector2 = Vector2.ZERO  # Vitesse du bâton
var stick_position: Vector2 = Vector2.ZERO  # Position du bâton
var is_attached: bool = false

# Limites de la zone (comme pour le joueur)
@export var barrier_min_x: float = 100.0  # Limite gauche de la zone
@export var barrier_max_x: float = 900.0  # Limite droite de la zone
@export var barrier_min_y: float = 0.0  # Limite supérieure de la zone
@export var barrier_max_y: float = 400.0  # Limite inférieure de la zone

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Stick.visible = false
	# pass # Replace with function body.

func _input(event: InputEvent) -> void:
	# Détecter un clic gauche pour tirer
	if Input.is_action_just_pressed("use") and not is_attached:
		shoot()

# Fonction pour tirer le bâton dans la direction de la souris
func shoot() -> void:
	# Calculer la direction du tir basée sur la souris
	var mouse_position = get_global_mouse_position()  # Position de la souris dans la scène
	var direction = (mouse_position - global_position).normalized()  # Calculer la direction du tir

	velocity = direction * shoot_speed  # Appliquer la vitesse du tir
	stick_position = global_position  # Position initiale du tir
	$Stick.visible = true  # Rendre visible le bâton lors du tir
	is_attached = false
	print("Tir du bâton dans la direction : ", direction)
	

# Fonction _process() ou _physics_process() pour mettre à jour la position du bâton
func _process(delta: float) -> void:
	if velocity.length() > 0:
		# Déplacer le bâton dans la direction
		stick_position += velocity * delta
		clamp_position()  # Limiter la position du bâton avec les barrières
		global_position = stick_position  # Mise à jour de la position du bâton
		

# Fonction pour limiter la position du bâton avec les barrières invisibles
func clamp_position() -> void:
	# Limiter la position du bâton pour ne pas dépasser les frontières
	stick_position.x = clamp(stick_position.x, barrier_min_x, barrier_max_x)
	stick_position.y = clamp(stick_position.y, barrier_min_y, barrier_max_y)
	
func _on_Area2D_body_entered(body: Node) -> void:
	# Si le bâton touche un mur (ici les barrières invisibles), il doit s'attacher
	if not is_attached:
		attach_to_wall()
	
	# Fonction attach_to_wall() pour gérer l'attachement du bâton

func attach_to_wall() -> void:
	velocity = Vector2.ZERO  # Stopper le mouvement du bâton
	is_attached = true
	print("Ventouse attachée à la position :", stick_position)
	
	global_position = stick_position
	$Stick.visible = false  # Cacher le bâton une fois attaché)
	# Créer la plateforme (le bâton est maintenant une plateforme sur le mur)
	if platform_scene:
		var platform = platform_scene.instantiate()
		platform.position = stick_position  # Position de la plateforme
		get_parent().add_child(platform)
	
