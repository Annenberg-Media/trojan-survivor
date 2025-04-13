extends CharacterBody2D
class_name Enemy

static var exp_orb_pickup = preload("res://Scenes/exp_orb_pickup.tscn")
 

func on_death() -> void:
	# drop pickup
	var new_exp_pickup: Node2D = exp_orb_pickup.instantiate()
	new_exp_pickup.global_position = global_position
	
	get_tree().root.get_node("Game").call_deferred("add_child", new_exp_pickup)
	
	# delete unit
	queue_free()
