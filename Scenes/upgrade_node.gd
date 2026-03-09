extends Node2D
class_name UpgradeNode

## Reference to the unit this is affecting
var target

var data: UpgradeData = null


func effect_enter():
	if target and data:
		if target is Player:
			data.effect.apply_effect(target)
			print("Enter: " + data.to_string())


func effect_exit():
	if target and data:
		if target is Player:
			data.effect.undo_effect(target)
			print("Exit: " + data.to_string())


func _on_duration_timer_timeout() -> void:
	effect_exit()
	queue_free()
