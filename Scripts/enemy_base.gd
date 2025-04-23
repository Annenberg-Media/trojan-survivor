extends CharacterBody2D
class_name Enemy

var drops = [
	"res://Scenes/speed_boost_pickup.tscn",
	"res://Scenes/multi_shot_pickup.tscn"
]

func on_death() -> void:
	# drop pickup
	var new_exp_pickup: Node2D
	if randf() > 0.1:
		new_exp_pickup = load("res://Scenes/exp_orb_pickup.tscn").instantiate()
	else:
		new_exp_pickup = load(drops.pick_random()).instantiate()
		
	new_exp_pickup.global_position = global_position
	GameManager.Instance.call_deferred("add_child", new_exp_pickup)
	Scoring.add_score(5)
	# delete unit
	queue_free()
