extends CanvasLayer

var pages = [
	{
		"layout": "sprites_bottom", 
		"text": [
			"[center]Welcome to Trojan Survivors![/center]",
			"[center]Mascots from rival schools are invading campus!\nHow long can you fend them off?[/center]"],
		"sprites": ["res://Resources/matcha_latte.png", "res://Resources/heal.png"]
	},
	{
		"layout": "sprites_beside", 
		"title": "[center]title I guess[/center]",
		"lines": [
			{"text": "PICKUPS", "sprite": "res://Resources/pickup_sprites/multishot_pickup.png"},
			{"text": "ORBS", "sprite": "res://Resources/pickup_sprites/exporb_pickup.png"}
		]
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
var page_idx: int = 1

func _update_page():
	# clear existing children of vbox first!
	for child in vbox.get_children():
		child.queue_free()
		
	var curr_page = pages[page_idx]
	print(curr_page["layout"])
	if curr_page["layout"] == "sprites_bottom":
		for text in curr_page["text"]:
			var label = RichTextLabel.new()
			label.text = text
			label.bbcode_enabled = true
			label.add_theme_font_size_override("normal_font_size", 28)
			label.size_flags_vertical = Control.SIZE_EXPAND_FILL
			vbox.add_child(label)
		
		var hbox = HBoxContainer.new()
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		for sprite_path in curr_page["sprites"]:
			var container = Control.new()
			container.custom_minimum_size = Vector2(64, 64)
			container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			container.size_flags_vertical = Control.SIZE_SHRINK_CENTER

			var tex = TextureRect.new()
			tex.texture = load(sprite_path)
			tex.set_anchors_preset(Control.PRESET_FULL_RECT)  # fill the parent Control
			tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
			container.add_child(tex)
			hbox.add_child(container)  # add container to hbox instead of tex directly
		vbox.add_child(hbox)
		
	elif curr_page["layout"] == "sprites_beside":
		var title = RichTextLabel.new()
		title.text = curr_page["title"]
		title.bbcode_enabled = true
		title.add_theme_font_size_override("normal_font_size", 28)
		title.custom_minimum_size = Vector2(0, 90)
		title.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		vbox.add_child(title)
		
		for line in curr_page["lines"]:
			var hbox = HBoxContainer.new()
			var container = Control.new()
			container.custom_minimum_size = Vector2(64, 64)
			container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			var tex = TextureRect.new() 
			var label = RichTextLabel.new()
			var line_txt = line["text"]
			var sprite_path = line["sprite"]
			
			label.text = line_txt
			label.bbcode_enabled = true
			label.add_theme_font_size_override("normal_font_size", 28)
			label.custom_minimum_size = Vector2(200, 60)
			label.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
			tex.texture = load(sprite_path)
			label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			hbox.add_child(label)
			container.add_child(tex)
			vbox.add_child(container)
			vbox.add_child(hbox)
	
func _ready():
	_update_page()
