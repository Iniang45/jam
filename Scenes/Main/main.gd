extends Control
var objetPorte = ""
var listeItems ={}
signal buttonClick(nom_button,niveau)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	listeItems["piocheBulle"] = false
	listeItems["grosluffyBulle"] = false
	listeItems["LanceVentouseBulle"] = false
	listeItems["ArbreBulle"] = false
	listeItems["GrabBulle"] = false
	listeItems["LanceurBulleBulle"] = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
			
	
	if Input.is_action_just_pressed("use") and objetPorte == "Pioche":
		$Player/Pioche/Sprite2D.play()
	if Input.is_action_just_pressed("camera2"):
		$Camera2D.position.x = 1724
		$Camera2D.position.y = 330
func pioche(niveau) -> void:
	print("pioche")
	$Player/Pioche.visible = true
	objetPorte = "piocheBulle"
	listeItems[str(objetPorte)] = true


func gros_luffy() -> void:
	print("grosLuffy")
	$cadre/niveau1/grosluffy/CollisionShape2D.set_disabled(false)
	$cadre/niveau1/grosluffyBulle.visible = false
	$cadre/niveau1/grosluffy.visible = true
	objetPorte = "grosLuffy"
	listeItems[objetPorte] = true
	
	


func _on_player_ilamange() -> void:
	$cadre/niveau1/grosluffy.visible = false




func _on_button_click(nom_button: Variant, niveau: Variant) -> void:
	print("but would you lose")
	match nom_button:
		"piocheBulle":
			pioche("niveau1")
