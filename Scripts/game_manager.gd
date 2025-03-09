extends Node2D


@export var spawn_interval: float = 2.0

var enemy_1_scene = preload("res://Scenes/enemy_1.tscn")
var screen_rect 
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if enemy_1_scene == null:
		print("ERROR: enemy 1 scene is null!")
		return
	spawn_enemy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawn_enemy():
	var enemy1 = enemy_1_scene.instantiate()
	if enemy1 == null:
		print("ERROR: Enemy instantiation failed")
		return 
	enemy1.position = $"../Player".position + Vector2(200, 200)
	
	add_child(enemy1)
