extends Control
class_name HealthDisplay

@onready var health_icon_container: HBoxContainer = %HealthIconContainer
const HEALTH_ICON = preload("res://Resources/health_icon.png")

@export var starting_count: int = 0
@export var heart_color: Color = Color.DARK_RED

func _ready() -> void:
	set_count(starting_count)

func set_count(count: int) -> void:
	for child: Control in health_icon_container.get_children():
		child.visible = count > 0
		child.self_modulate = heart_color
		count -= 1
	
	# make more icons if count is more than current max
	while count > 0:
		var new_icon: TextureRect = TextureRect.new()
		new_icon.texture = HEALTH_ICON
		new_icon.self_modulate = heart_color
		health_icon_container.add_child(new_icon)
		count -= 1
