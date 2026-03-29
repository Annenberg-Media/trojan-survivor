extends CanvasLayer

@onready var content_txt = $TextureRect/MarginContainer/VBoxContainer/Content
@onready var next_btn = $TextureRect/MarginContainer/VBoxContainer/HBoxContainer/NextBtn
@onready var prev_btn = $TextureRect/MarginContainer/VBoxContainer/HBoxContainer/PrevBtn

var txt_idx: int = 0
var txt_content = [
	"[ul]
	Fend off mascots from rival schools!
	WASD keys to move
	Left click to throw[/ul]", 
	"[ul]
	Pickups give temporary effects!
	Collect enough School Spirit Orbs for a short boost![/ul]"
]

func _ready():
	_update_txt()
	next_btn.pressed.connect(_on_next)
	prev_btn.pressed.connect(_on_prev)
	
func _on_prev():
	if txt_idx > 0:
		txt_idx -= 1
	_update_txt()
	
func _on_next():
	if txt_idx < len(txt_content)-1:
		txt_idx += 1
	elif txt_idx == len(txt_content)-1:
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	_update_txt()

func _update_txt():
	if txt_idx == len(txt_content)-1:
		next_btn.text = "Start Game!"
	content_txt.text = txt_content[txt_idx]
