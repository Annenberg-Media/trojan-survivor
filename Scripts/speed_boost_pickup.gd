extends Node2D

## Reference to the unit this is affecting
var target

@export
var boost_amount: float = 100
@export
var duration: float = 3

@onready var pickup_text_template = preload("res://Scenes/pickup_text.tscn")


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
		
		var new_pickup_text = pickup_text_template.instantiate()
		add_child(new_pickup_text)
		new_pickup_text.set_text_animate("SPEED BOOST!")


func _on_duration_timer_timeout() -> void:
	effect_exit()
	queue_free()
