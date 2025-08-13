extends Node2D

## Reference to the unit this is affecting
var target

@export
var exp_amount: int = 100


func effect_enter():
	if target:
		if target is Player:
			target.add_exp(exp_amount)


func effect_exit():
	return


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		$Sprite2D.visible = false
		effect_enter()
		queue_free()


func _on_duration_timer_timeout() -> void:
	effect_exit()
	queue_free()
