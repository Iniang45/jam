extends CharacterBody2D  # Stickgun

# Propriétés
var speed = 200  # Vitesse constante
var direction = Vector2.RIGHT  # Déplacement vers la droite
var is_moving = false  # Indique si la ventouse bouge

# Référence vers le RayCast2D
@onready var ray = $RayCast2D

func _physics_process(delta):
	if is_moving:
		# Vérifie si le RayCast2D détecte une collision
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider and collider is Area2D:  # Vérifie si l'objet touché est une Area2D
				print("Collision détectée avec une Area2D :", collider.name)
				is_moving = false  # Arrête le mouvement
				velocity = Vector2.ZERO  # Stoppe la vitesse
		else:
			# Si aucune collision, continue le déplacement
			velocity = direction * speed
			move_and_slide()

func _input(event):
	if event.is_action_pressed("use") and not is_moving:
		print("Action 'usu' détectée : La ventouse commence à bouger")
		is_moving = true
