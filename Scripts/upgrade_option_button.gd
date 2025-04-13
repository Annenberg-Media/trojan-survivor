extends Button

@export var index: int = 0

signal option_selected(num)

func _pressed() -> void:
	option_selected.emit(index)
