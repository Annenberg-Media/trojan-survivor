extends Enemy

@onready var player = get_tree().get_current_scene().get_node("Player")
var attacking = false
var player_in_area = null


func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if player and not attacking:
		var direction = (player.position - position).normalized()
		velocity = direction * 85
	elif attacking:
		velocity = Vector2.ZERO
		
	move_and_slide()
		
func is_enemy():
	return true


func _on_player_interaction_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_area = body
		if not attacking:
			print("DEBUG: player hit by melee enemy")
			attacking = true
			body.receive_hit()
			$HitTimer.start()


func _on_hit_timer_timeout() -> void:
	attacking = false
	if player_in_area != null:
		player_in_area.receive_hit()
		attacking = true
		$HitTimer.start()
	else:
		$HitTimer.stop()


func _on_player_interaction_body_exited(body: Node2D) -> void:
	if body == player_in_area:
		player_in_area = null
