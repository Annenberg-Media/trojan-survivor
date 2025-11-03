extends Enemy

@onready var player = get_tree().get_current_scene().get_node("Player")
var move_speed = 50
var player_in_area = null
var attacking = false
var armor = true
@onready var anim_sprite := get_node_or_null("AnimatedSprite2D")

func _physics_process(delta: float) -> void:
	if disabled:
		fly_away(delta)
		return
		
	if player and not attacking:
		var direction = (player.position - position).normalized()
		velocity = direction * move_speed
		
		if anim_sprite:
			if armor:
				anim_sprite.play("move_shielded")
			else:
				anim_sprite.play("move_unshielded")
			if player.global_position.x > global_position.x:
				anim_sprite.flip_h = true
			else:
				anim_sprite.flip_h = false
				
	elif attacking:
		velocity = Vector2.ZERO
		
	move_and_slide()
	
func is_enemy() -> bool:
	return true
	
func enemy_increase_speed() -> void:
	move_speed = 100
	
func enemy_revert_speed() -> void:
	move_speed = 50


func _on_hit_timer_timeout() -> void:
	attacking = false
	if player_in_area != null:
		player_in_area.receive_hit()
		attacking = true
		$HitTimer.start()
	else:
		$HitTimer.stop()	


func _on_player_interaction_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_area = body
		if not attacking:
			print("DEBUG: player hit by melee enemy")
			attacking = true
			body.receive_hit()
			$HitTimer.start()


func _on_player_interaction_body_exited(body: Node2D) -> void:
	if body == player_in_area:
		player_in_area = null
		attacking = false
		
func tank_hit() -> bool:
	if armor:
		armor = false
		return true
	else:
		return false
