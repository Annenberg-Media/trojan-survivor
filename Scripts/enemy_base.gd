extends CharacterBody2D
class_name Enemy

var drops = [
	"res://Scenes/speed_boost_pickup.tscn",
	"res://Scenes/multi_shot_pickup.tscn"
]

var animation_player: AnimationPlayer
var player_direction: Vector2
var disabled: bool = false
var fly_speed := 350
var free_distance := 1000
var free_timer : Timer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	animation_player = get_node("AnimationPlayer")
	
func on_death() -> void:
	# drop pickup
	var new_exp_pickup: Node2D
	if randf() > 0.1:
		new_exp_pickup = load("res://Scenes/exp_orb_pickup.tscn").instantiate()
	else:
		new_exp_pickup = load(drops.pick_random()).instantiate()
		
	new_exp_pickup.global_position = global_position
	GameManager.Instance.call_deferred("add_child", new_exp_pickup)
	
	# add scores
	Scoring.add_score(5)
	GameManager.Instance.add_score(5)
	
	# save snapshot of player direction
	player_direction = global_position.direction_to(
		GameManager.Instance.player.global_position)
	
	# mark as dead
	disabled = true
	modulate.a = 0.7
	collision_layer = 0
	animation_player.play("spin")

func fly_away(delta) -> void:
	global_position += delta * fly_speed * -player_direction
	if global_position.distance_to(GameManager.Instance.player.global_position) > 1000:
		print("freed enemy")
		queue_free()
