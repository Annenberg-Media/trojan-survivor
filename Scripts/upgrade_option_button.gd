extends Button
class_name UpgradeOptionButton

@export var index: int = 0

@onready var name_label: Label = $MarginContainer/VBoxContainer/NameLabel
@onready var description_label: Label = $MarginContainer/VBoxContainer/DescLabel
@onready var upgrade_icon: TextureRect = $MarginContainer/VBoxContainer/Icon

signal option_selected(num)

func _pressed() -> void:
	option_selected.emit(index)
