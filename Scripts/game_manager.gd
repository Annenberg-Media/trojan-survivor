extends Node2D
class_name GameManager

static var Instance

var hud
var player: Player

signal time_changed(new_time: float)
signal score_changed(new_score: int)

@export var spawn_interval: float = 2.0

var enemy_list = [
	preload("res://Scenes/enemy_1.tscn"),
	preload("res://Scenes/enemy_2.tscn"),
	preload("res://Scenes/enemy_3.tscn"),
	preload("res://Scenes/enemy_4.tscn")
]

var rng = RandomNumberGenerator.new()
@onready var spawnTimer = $EnemySpawnTimer

var game_time: float = 0
var score: int = 0

var past_twenty = false
var past_forty = false
var past_sixty = false

## Upgrade Resources
var upgrade_list = [
	preload("res://Scripts/Upgrades/Resources/skateboard.tres"),
	preload("res://Scripts/Upgrades/Resources/MatchaLatte.tres")
]
var current_upgrade_options = []
var upgrade_option_count: int = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.Instance = self
	hud = $Hud/HUD
	score_changed.connect(hud._on_score_changed)
	time_changed.connect(hud._on_time_changed)
	
	player = $Player
	player.gained_level.connect(_on_player_levelup)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# calls function to check if certain in-game times have been met 
	# to decrease enemy spawn timer
	check_decrement_spawn_timer(Time.get_ticks_msec()/1000.0)
		
	game_time += delta
	emit_signal("time_changed", game_time)
	
func spawn_enemy(num: int):
	for i in range(num):
		var rand_enemy_type = randi_range(1, 4)
		print("SPAWNING: Type ", rand_enemy_type)
		
		var new_enemy = enemy_list[rand_enemy_type-1].instantiate()
		new_enemy.position = enemy_spawn_position()
		add_child(new_enemy)
		await get_tree().process_frame


func enemy_spawn_position():
	# Generates a random enemy spawn position, just outside of camera visible range
	
	# Camera and viewport related variables
	var camera = get_viewport().get_camera_2d()
	var viewport_size = get_viewport().size
	var camera_position = camera.global_position
	
	# Determine random spawn position
	var spawn_offset = 100 # pixel distance beyond visible range
	var spawn_side = randi() % 4 # 0=Left, 1=Right, 2=Top, 3=Bottom
	var spawn_position = Vector2.ZERO
	
	match spawn_side:
		0:
			spawn_position = Vector2(camera_position.x - viewport_size.x/2 - spawn_offset, 
			randf_range(camera_position.y - viewport_size.y/2, camera_position.y + viewport_size.y/2))
		1:
			spawn_position = Vector2(camera_position.x + viewport_size.x/2 + spawn_offset, 
			randf_range(camera_position.y - viewport_size.y/2, camera_position.y + viewport_size.y/2))
		2:
			spawn_position = Vector2(randf_range(camera_position.x - viewport_size.x/2, camera_position.x + viewport_size.x/2),
			camera_position.y - viewport_size.y/2 - spawn_offset)
		3:
			spawn_position = Vector2(randf_range(camera_position.x - viewport_size.x/2, camera_position.x + viewport_size.x/2),
			camera_position.y + viewport_size.y/2 + spawn_offset)
			
	return spawn_position


func _on_enemy_spawn_timer_timeout() -> void:
	var num_enemies = randi_range(1, 3)
	print("Timer end; spawning ", num_enemies, " enemies!")
	spawn_enemy(num_enemies)
	# print("Spawning more enemies in: ", spawnTimer.wait_time, " seconds")
	
	
func add_score(points: int) -> void:
	score += points
	emit_signal("score_changed", score)
	
func check_decrement_spawn_timer(game_time: float):
	if game_time >= 20 and not past_twenty:
		print("DEBUG: player survived 20 seconds. decrementing timer")
		past_twenty = true
		spawnTimer.wait_time -= 0.5
		
	if game_time >= 40 and not past_forty:
		print("DEBUG: player survived 40 seconds. decrementing timer further")
		past_forty = true
		spawnTimer.wait_time -= 0.5
		
	if game_time >= 60 and not past_sixty:
		print("DEBUG: player survived a minute. decrementing timer")
		past_sixty = true
		spawnTimer.wait_time -= 0.5

func _on_player_game_over() -> void:
	call_deferred("_go_to_title")
	
func _go_to_title() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_player_levelup() -> void:
	# pause game
	print("PAUSE GAME")
	get_tree().paused = true
	
	# generate options
	current_upgrade_options.clear()
	for i in range(upgrade_option_count):
		current_upgrade_options.append(upgrade_list.pick_random())
	
	# show upgrade menu
	hud.show_upgrade_menu(current_upgrade_options)
	print("Options: " + str(current_upgrade_options))
	
	# wait for player to choose
	var selected_index: int = await hud.upgrade_selected
	print("Selected option: " + str(current_upgrade_options[selected_index]))
	
	# apply upgrade to player
	current_upgrade_options[selected_index].effect.apply_effect(player)
	
	# resume game
	print("RESUME GAME")
	get_tree().paused = false
