extends Control
class_name EXPBar

@onready var animated_progress_bar: AnimatedProgressBar = $AnimatedProgressBar
@onready var label: Label = $Label

func set_exp_amount(current_val: float, max_val: float) -> void:
	animated_progress_bar.max_value = max_val
	animated_progress_bar.set_bar_value(current_val)
	label.text = str(int(current_val)) + " / " + str(int(max_val))
