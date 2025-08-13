extends Control
class_name HealthDisplay

@onready var health_icon_container: HBoxContainer = %HealthIconContainer
const HEALTH_ICON = preload("res://Resources/health_icon.png")

@export var starting_count: int = 0
@export var heart_color: Color = Color.RED
@export var disabled_heart_color: Color = Color.DIM_GRAY

func _ready() -> void:
	set_count(starting_count)

func set_count(count: int) -> void:
	while health_icon_container.get_child_count() < count:
		var new_icon: TextureRect = TextureRect.new()
		new_icon.texture = HEALTH_ICON
		new_icon.self_modulate = disabled_heart_color
		health_icon_container.add_child(new_icon)
		
	for i: int in range(health_icon_container.get_child_count()-1, -1, -1):
		health_icon_container.get_child(i).self_modulate = disabled_heart_color if count <= 0 else heart_color
		count -= 1
