extends Control

@onready var music_player = $BackgroundMusic  # Référence au nœud AudioStreamPlayer

var objetPorte = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Démarrer la musique lorsque la scène est prête
	if not music_player.playing:
		music_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("use") and objetPorte == "Pioche":
		$cadre/Player/Pioche/Sprite2D.play()
	if Input.is_action_just_pressed("camera2"):
		$Camera2D.position.x = 1724
		$Camera2D.position.y = 330
func _on_pioche_bulle_pressed() -> void:
	print("pioche")
	$cadre/niveau1/piocheBulle.visible = false
	$cadre/Player/Pioche.visible = true
	objetPorte = "Pioche"


func _on_grosluffy_bulle_pressed() -> void:
	print("grosLuffy")
	$cadre/niveau1/grosluffy/CollisionShape2D.set_disabled(false)
	$cadre/niveau1/grosluffyBulle.visible = false
	$cadre/niveau1/grosluffy.visible = true
	objetPorte = "grosLuddy"


func _on_player_ilamange() -> void:
	$cadre/niveau1/grosluffy.visible = false


func _on_niveau_1_text_changed() -> void:
	$cadre/Narrateur/AnimatedSprite2D.play()


func _on_lance_ventouse_bulle_pressed() -> void:
	pass # Replace with function body.


func _on_lanceur_bulle_bulle_pressed() -> void:
	pass # Replace with function body.


func _on_grab_bulle_pressed() -> void:
	pass # Replace with function body.


func _on_arbre_bulle_pressed() -> void:
	pass # Replace with function body.
