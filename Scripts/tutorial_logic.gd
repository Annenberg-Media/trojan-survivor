extends CanvasLayer

var pages = [
	{
		"layout": "sprites_bottom", 
		"text": "[center]Mascots from rival schools are invading campus!\nHow long can you fend them off?[/center]",
		"sprites": ["placeholder"]
	},
	{
		"layout": "sprites_beside", 
		"lines": [
			{"text": "FIRST LINE", "sprite": "placeholder"},
			{"text": "SECOND LINE", "sprite": "placeholder"}
		]
	}
]

@onready var vbox = $TextureRect/MarginContainer/VBoxContainer
var page_idx: int = 0

func _update_page():
	# clear existing children of vbox first!
	for child in vbox.get_children():
		child.queue_free()
		
	var curr_page = pages[page_idx]
	print(curr_page["layout"])
	if curr_page["layout"] == "sprites_bottom":
		print("sprites will be drawn at bottom!")
		
	elif curr_page["layout"] == "sprites_beside":
		print("sprites will be drawn beside each line!")
	
