extends Node2D

## Reference to the unit this is affecting
var target

@export
var boost_amount: float = 100
@export
var duration: float = 3


func effect_enter():
	if target:
		if target is Player:
			target.movement_speed += boost_amount


func effect_exit():
	if target:
		if target is Player:
			target.movement_speed -= boost_amount


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		$Sprite2D.visible = false
		$DurationTimer.start(duration)
		effect_enter()


func _on_duration_timer_timeout() -> void:
	effect_exit()
	queue_free()
