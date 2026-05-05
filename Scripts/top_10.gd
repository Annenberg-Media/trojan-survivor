extends Node2D

const NUM_RESULTS = 10
@onready var placements = [$CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/first, 
$CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/second,
$CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/third,
$CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/fourth, 
$CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/fifth,
$CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/sixth,
$CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/seventh,
$CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/eighth,
$CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/ninth,
$CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/tenth]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var query = FirestoreQuery.new()
	query.from("leaderboard")
	query.order_by("score", FirestoreQuery.DIRECTION.DESCENDING)
	query.limit(NUM_RESULTS)

	
	var results = await Firebase.Firestore.query(query)
	print("Type: ", typeof(results))
	print("Results: ", results)
	if results != null and results is Array:
		print("Array size: ", results.size())
		for i in range(len(results)):
			# print("Name: ", results[i].get_value("name"), "\nScore: ", results[i].get_value("score"))
			placements[i].text = results[i].get_value("name") + " : " + str(results[i].get_value("score"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
