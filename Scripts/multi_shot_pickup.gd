extends Node2D

var target

@export var extra_shots: int = 2 
@export var spread_angle: float = 15.0
@export var duration: float = 5.0

func effect_enter():
	if target and target is Player:
		target.multi_shot_active = true
		target.multi_shot_count = extra_shots + 1 
		target.multi_shot_spread = spread_angle

func effect_exit():
	if target and target is Player:
		target.multi_shot_active = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		$Sprite2D.visible = false
		$DurationTimer.start(duration)
		effect_enter()

func _on_duration_timer_timeout() -> void:
	effect_exit()
	queue_free()
