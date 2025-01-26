extends Control
var objetPorte = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("use") and objetPorte == "Pioche":
		$cadre/Player/Pioche/Sprite2D.play()

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
