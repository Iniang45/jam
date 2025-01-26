extends Control
@onready var touche = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player/PlayerSprite.animation = "idle"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
		
	#if Input.is_action_just_pressed("use") :
		#$Player/Pioche/Sprite2D.play()
			
#func _on_pioche_piocher() -> void:
	#if Input.is_action_just_pressed("use"):
		#$background/area2D/Sprite2D.texture = load("res://Sprite/jiren.PNG")
	


func _on_grosluffy_area_entered(area: Area2D) -> void:
	print("Le joueur mange un gâteau !")
	$Player/PlayerSprite.animation = "gros"
	$Player/PlayerSprite.play()
	$grosluffy.visible = false 
