extends Area2D

@export var velocity: Vector2 = Vector2.ZERO  # Vitesse initiale du bâton

func _process(delta: float) -> void:
	# Vérifier si le bâton doit se déplacer
	if velocity != Vector2.ZERO:
		position += velocity * delta
	else:
		print("La vélocité est nulle. Le bâton ne se déplace pas.")

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("walls"):
		# Arrêter le bâton en cas de collision
		velocity = Vector2.ZERO
		print("Bâton attaché à un mur")
		queue_free()
