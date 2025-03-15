extends Node2D


@export var spawn_interval: float = 2.0

var enemy_1_scene = preload("res://Scenes/enemy_1.tscn")
var enemy_2_scene = preload("res://Scenes/enemy_2.tscn")
var screen_rect 
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if enemy_1_scene == null:
		print("ERROR: enemy 1 scene is null!")
		return
	elif enemy_2_scene == null:
		print("ERROR: enemy 2 scene is null!")
		return
	spawn_enemy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawn_enemy():
	var enemy1 = enemy_1_scene.instantiate()
	var enemy2 = enemy_2_scene.instantiate()
	
	if enemy1 == null:
		print("ERROR: Enemy instantiation failed")
		return 
	enemy1.position = enemy_spawn_position()
	enemy2.position = enemy_spawn_position()
	
	add_child(enemy1)
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
			spawn_position = Vector2(randf_range(camera_position.x - viewport_size.x/2, camera_position.x + viewport_size/2),
			camera_position.y - viewport_size.y/2 - spawn_offset)
		3:
			spawn_position = Vector2(randf_range(camera_position.x - viewport_size.x/2, camera_position.x + viewport_size.x/2),
			camera_position.y + viewport_size.y/2 + spawn_offset)
			
	return spawn_position
	
	
