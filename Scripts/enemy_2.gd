extends Enemy

@onready var player = get_node("/root/Game/Player")
var enemy_bullet: PackedScene = preload("res://Scenes/enemy_projectile.tscn")
@onready var shoot_cooldown_timer = $ShootCooldown

var move_speed = 50


func _physics_process(_delta: float) -> void:
	# Move toward player until player in shooting range
	if player and (player.position - position).length() > 400:
		var direction = (player.position - position).normalized()
		velocity = direction * move_speed
		move_and_slide()
		
	# If player within range, shoot at player
	elif player and (player.position - position).length() <= 400 and shoot_cooldown_timer.is_stopped():
		shoot_at_player(player.global_position)
		
		
func shoot_at_player(dir: Vector2):
	var new_bullet = enemy_bullet.instantiate()
	new_bullet.position = global_position + (player.global_position - global_position).normalized()*90
	new_bullet.direction = (dir - global_position).normalized()
	get_tree().root.add_child(new_bullet)
	shoot_cooldown_timer.start()
	
	
func is_enemy():
	return true
	
func enemy_increase_speed() -> void:
	move_speed = 100
	
func enemy_revert_speed() -> void:
	move_speed = 50
