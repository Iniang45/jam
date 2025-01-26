extends Control
var objetPorte = ""
signal textChanged
@onready var texte = $bulle/Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var parent = get_parent()
	for items in parent.listeItems :
		if parent.listeItems[items] == true:
			var noeud = get_node(str(items))
			noeud.visible = false
	
			


	


	


func _on_main_button_click(nom_button: Variant, niveau: Variant) -> void:
	print("zehhahahahah")
	var parent = get_parent()
	if niveau == "niveau2":
		for items in parent.listeItems :
			print(str(items))
			get_node(str(items)).visible = false


func _on_pioche_bulle_pressed() -> void:
	var parent = get_parent()
	parent.buttonClick.emit("piocheBulle","niveau2")
