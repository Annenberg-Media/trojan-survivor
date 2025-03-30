extends Node2D

signal time_changed(new_time: float)
signal score_changed(new_score: int)

@export var spawn_interval: float = 2.0

var enemy_1_scene = preload("res://Scenes/enemy_1.tscn")
var enemy_2_scene = preload("res://Scenes/enemy_2.tscn")
var rng = RandomNumberGenerator.new()
@onready var spawnTimer = $EnemySpawnTimer

var game_time: float = 0
var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if enemy_1_scene == null:
		print("ERROR: enemy 1 scene is null!")
		return
	elif enemy_2_scene == null:
		print("ERROR: enemy 2 scene is null!")
		return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	'''
	=== Temporary code of timer getting faster and faster to spawn enemies ===
	faster as game progresses. It technically works, but I'm almost certain 
	that there will be a more elegant way to do this; will look into later :)
	if spawnTimer.wait_time > 1:
		spawnTimer.wait_time -= 0.1 * delta
	'''
	# pass
	game_time += delta
	emit_signal("time_changed", game_time)
	
func spawn_enemy(num: int):
	for i in range(num):
		var rand_enemy_type = randi_range(1, 2)
		print("SPAWNING: Type ", rand_enemy_type)
		match rand_enemy_type:
			1:
				var enemy1 = enemy_1_scene.instantiate()
				enemy1.position = enemy_spawn_position()
				add_child(enemy1)
			2:
				var enemy2 = enemy_2_scene.instantiate()
				enemy2.position = enemy_spawn_position()
				add_child(enemy2)


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
	
	
func add_score(points: int) -> void:
	score += points
	emit_signal("score_changed", score)
