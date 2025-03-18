extends Node2D

var target

@export
var boost_amount: int = 1

func effect_enter():
	if target:
		if target is Player:
			target.current_health += boost_amount
			if target.current_health > target.get_max_health():
				target.health_overload = target.current_health - target.get_max_health() 
				target.current_health = target.get_max_health()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		$Sprite2D.visible = false
		effect_enter()
		queue_free()
