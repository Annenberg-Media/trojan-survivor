extends CanvasLayer

var pages = [
	{
		"layout": "sprites_bottom", 
		"title": "[center]Welcome to Trojan Survivors![/center]",
		"text": [
			"[center]Mascots from rival schools are invading campus!\nHow long can you fend them off?[/center]", 
			"[center]Each rival has a unique attack/effect...[/center]"],
		"sprites": [
			"res://Resources/still_sprites/bruinbear.png", 
			"res://Resources/still_sprites/caltechbeaver.png", 
			"res://Resources/still_sprites/leprechaun.png",
			"res://Resources/still_sprites/princetontiger.png",
			"res://Resources/still_sprites/sanjosestatespartan.png",
			"res://Resources/still_sprites/stanfordtree.png",
			"res://Resources/still_sprites/ucsb_slug.png",
			"res://Resources/still_sprites/ucsd_kingtriton.png"]
	},
	{
		"layout": "sprites_beside", 
		"title": "[center]Controls[/center]",
		"lines": [
			{"text": "Move with WASD keys...", "sprite": "res://Resources/still_sprites/wasd.png"},
			{"text": "Throw things with Left Mouse Click!", "sprite": "res://Resources/still_sprites/mouse.png"}
		]
	}, 
	{
		"layout": "sprites_beside", 
		"title": "[center]Opponent Drops[/center]",
		"lines": [
			{"text": "Pickups grant temporary upgrades!", "sprite": "res://Resources/still_sprites/pickups.png"},
			{"text": "Collect enough ``school spirit orbs'' for a boost! ", "sprite": "res://Resources/pickup_sprites/exporb_pickup.png"}
		]
	}
]

@onready var vbox = $TextureRect/MarginContainer/VBoxContainer
var page_idx: int = 0
var font = load("res://Resources/fonts/KiriFont.ttf")

func _update_page():
	# clear existing children of vbox first!
	for child in vbox.get_children():
		child.queue_free()
		
	var curr_page = pages[page_idx]
	# print(curr_page["layout"])
	var title = RichTextLabel.new()
	title.text = curr_page["title"]
	title.clip_contents = false
	title.bbcode_enabled = true
	title.add_theme_font_override("normal_font", font)
	title.add_theme_font_size_override("normal_font_size", 40)
	title.custom_minimum_size = Vector2(0, 60)
	title.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	vbox.add_child(title)
		
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
			container.custom_minimum_size = Vector2(90, 90)
			container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			container.size_flags_vertical = Control.SIZE_SHRINK_CENTER

			var tex = TextureRect.new()
			tex.texture = load(sprite_path)
			tex.set_anchors_preset(Control.PRESET_FULL_RECT)  # fill the parent Control
			tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
			container.add_child(tex)
			hbox.add_child(container)  # add container to hbox instead of tex directly
		vbox.add_child(hbox)
		
		# navigation buttons
		var btn_hbox = HBoxContainer.new()
		btn_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		btn_hbox.custom_minimum_size = Vector2(700, 40)
		var prev_btn = Button.new()
		prev_btn.text = "Previous"
		var next_btn = Button.new()
		next_btn.text = "Next"
		prev_btn.pressed.connect(_on_prev)
		next_btn.pressed.connect(_on_next)
		
		var spacer = Control.new()
		spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn_hbox.add_child(prev_btn)
		btn_hbox.add_child(spacer)
		btn_hbox.add_child(next_btn)
		var v_spacer = Control.new()
		v_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
		vbox.add_child(v_spacer)
		vbox.add_child(btn_hbox)
		
	elif curr_page["layout"] == "sprites_beside":
		for line in curr_page["lines"]:
			var hbox = HBoxContainer.new()
			hbox.custom_minimum_size = Vector2(0, 60)
			hbox.alignment = BoxContainer.ALIGNMENT_CENTER
			hbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

			var container = Control.new()
			container.custom_minimum_size = Vector2(100, 130)
			container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			container.size_flags_vertical = Control.SIZE_SHRINK_CENTER

			var tex = TextureRect.new()
			var label = RichTextLabel.new()
			var line_txt = line["text"]
			var sprite_path = line["sprite"]

			label.text = line_txt
			label.bbcode_enabled = true
			label.add_theme_font_size_override("normal_font_size", 28)
			label.custom_minimum_size = Vector2(700, 80)
			label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			label.size_flags_vertical = Control.SIZE_SHRINK_CENTER

			tex.texture = load(sprite_path)
			tex.set_anchors_preset(Control.PRESET_FULL_RECT)
			tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
			container.add_child(tex)
			
			hbox.add_child(label)
			hbox.add_child(container)
			vbox.add_child(hbox)
		
		# navigation buttons
		var btn_hbox = HBoxContainer.new()
		btn_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		btn_hbox.custom_minimum_size = Vector2(700, 40)
		var prev_btn = Button.new()
		prev_btn.text = "Previous"
		var next_btn = Button.new()
		if page_idx < len(pages) - 1:
			next_btn.text = "Next"
		elif page_idx == len(pages) -1: 
			next_btn.text = "Start Game!"
		prev_btn.pressed.connect(_on_prev)
		next_btn.pressed.connect(_on_next)
		
		var spacer = Control.new()
		spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn_hbox.add_child(prev_btn)
		btn_hbox.add_child(spacer)
		btn_hbox.add_child(next_btn)
		var v_spacer = Control.new()
		v_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
		vbox.add_child(v_spacer)
		vbox.add_child(btn_hbox)
	
func _ready():
	_update_page()
	
func _on_prev():
	if page_idx >= 1:
		page_idx -= 1
		_update_page()

func _on_next():
	if page_idx < len(pages)-1:
		page_idx += 1
		_update_page() 
	elif page_idx == len(pages)-1:
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
