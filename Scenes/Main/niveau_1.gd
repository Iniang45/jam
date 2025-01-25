extends Control

@onready var texte = $bulle/Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texte.text = "je sais pas si vous le savez mais yugiooohoh"
	await get_tree().create_timer(5).timeout
	texte.text = "noooon pas le jujutsu kaisen"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
