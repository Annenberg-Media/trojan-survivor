extends TextureProgressBar
class_name AnimatedProgressBar

@export
## The time it takes to reach the target value
var fill_time: float = 0.5

var init_value: float = 0
var target_value: float = 0
var _progress: float = 0


func _physics_process(delta: float) -> void:
	if abs(value - target_value) < 0.1:
		value = target_value
	else:
		value = lerp(init_value, target_value, _progress / fill_time)
		_progress += delta


func set_bar_value(new_value: float, instant: bool = false) -> void:
	if instant:
		value = new_value
		return
	
	init_value = value
	target_value = new_value
	_progress = 0
