extends Node2D

@onready var text = $CanvasLayer/MarginContainer/VBoxContainer/RichTextLabel
@onready var lineEdit = $CanvasLayer/MarginContainer/VBoxContainer/LineEdit
@onready var submitBtn = $CanvasLayer/MarginContainer/VBoxContainer/submitBtn
var final_score:int = 0
var submit_pressed:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text.text = "FINAL SCORE: %d" % final_score


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_submit_btn_pressed() -> void:
	var player_name = lineEdit.text.strip_edges()
	if player_name.is_empty():
		return
	
	lineEdit.editable = false
	submitBtn.disabled = true
	
	var collection = Firebase.Firestore.collection("leaderboard")
	var doc_id = Firebase.Auth.auth.localid
	
	# Check existing score
	var existing = await collection.get_doc(doc_id)
	
	var existing_score = 0
	if existing != null:
		var prev = existing.get_value("score")
		if prev != null:
			existing_score = int(prev)
	
	if final_score <= existing_score:
		print("Existing score (%d) is higher; not overwriting" % existing_score)
		return
	
	# New best — write it
	var data = {
		"name": player_name,
		"score": final_score,
		"timestamp": int(Time.get_unix_time_from_system())
	}
	await collection.set_doc(doc_id, data)
	print("New high score submitted!")


func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_play_again_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_leaderboard_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/top10.tscn")
