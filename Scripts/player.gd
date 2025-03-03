extends CharacterBody2D

@export
## player's movement speed in pixels per second
var movement_speed: float = 400

func _physics_process(delta: float) -> void:
	var move_dir: Vector2 = Vector2.ZERO
	# W - up
	if Input.is_action_pressed("ui_up"):
		move_dir += Vector2.UP
	# A - left
	if Input.is_action_pressed("ui_left"):
		move_dir += Vector2.LEFT
	# S - down
	if Input.is_action_pressed("ui_down"):
		move_dir += Vector2.DOWN
	# D - right
	if Input.is_action_pressed("ui_right"):
		move_dir += Vector2.RIGHT
	move_dir = move_dir.normalized()
	
	global_position += move_dir * (movement_speed * delta)
