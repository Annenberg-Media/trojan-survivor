extends Node2D

@onready var text = $CanvasLayer/MarginContainer/VBoxContainer/RichTextLabel
@onready var lineEdit = $CanvasLayer/MarginContainer/VBoxContainer/LineEdit
var final_score:int = 0
var submit_pressed:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text.text = "FINAL SCORE: %d" % final_score


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_submit_btn_pressed() -> void:
	var entered_name = lineEdit.text.strip_edges()
	if entered_name.is_empty():
		return 
		
	lineEdit.editable = false
	if not submit_pressed:
		submit_pressed = true
		
		var collection = Firebase.Firestore.collection("leaderboard")
		var data = {"name": entered_name, "score": final_score}
		var doc_id = Firebase.Auth.auth.localid
		collection.add(doc_id, data)
		
		print("%s submitted score!" % entered_name)


func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_play_again_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
