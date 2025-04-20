extends CharacterBody2D
class_name Enemy


func on_death() -> void:
	# drop pickup
	var new_exp_pickup: Node2D = load("res://Scenes/exp_orb_pickup.tscn").instantiate()
	new_exp_pickup.global_position = global_position
	GameManager.Instance.call_deferred("add_child", new_exp_pickup)
	Scoring.add_score(5)
	# delete unit
	queue_free()
