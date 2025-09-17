extends Enemy

var exploding_coin_scene = preload("res://Scenes/exploding_coin.tscn")

var move_speed = 30.0
var original_speed = 30.0

@export var coin_drop_interval: float = 3.0

var player: Node2D

@onready var coin_drop_timer: Timer = $CoinDropTimer

# TODO : Nat - need to figure out movement for this

func _ready() -> void:
	super._ready()
	
	player = get_tree().get_first_node_in_group("player")
	setup_timers()

func setup_timers():
	# Delay before coin start to drop
	var offset_timer: Timer = Timer.new()
	add_child(offset_timer)
	offset_timer.start(randf_range(0, 1))
	await offset_timer.timeout
	coin_drop_timer.start(coin_drop_interval)
	
	coin_drop_timer.timeout.connect(_on_coin_drop_timer_timeout)

func _physics_process(delta: float) -> void:
	if disabled:
		fly_away(delta)
		return
		
	if not player:
		return
		
	# Dir to player
	var direction = (player.global_position - global_position).normalized()
	
	# Set velocity and move towards the player
	velocity = direction * move_speed
	move_and_slide()

func _on_coin_drop_timer_timeout() -> void:
	drop_exploding_coin()

# New coin and random positions
func drop_exploding_coin():
	var new_coin: Node2D = exploding_coin_scene.instantiate()
	
	# random coin in random direction
	var offset_distance = randf_range(75, 100)
	
	
	var random_angle = randf() * TAU
	
	var offset = Vector2(
		cos(random_angle) * offset_distance,
		sin(random_angle) * offset_distance
	)

	new_coin.global_position = global_position + offset
	GameManager.Instance.call_deferred("add_child", new_coin)
	
	print("Leprechaun dropped an exploding coin at: ", offset)

# Todo: Consider override for scoring later

func is_enemy() -> bool:
	return true
	
func enemy_increase_speed() -> void:
	move_speed = original_speed * 1.5
	
func enemy_revert_speed() -> void:
	move_speed = original_speed
