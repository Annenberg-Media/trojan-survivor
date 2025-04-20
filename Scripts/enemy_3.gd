extends Enemy

var move_speed = 0

func _physics_process(delta: float) -> void:
	pass


func _on_buff_area_body_entered(body: Node2D) -> void:
	if body.has_method("is_enemy"):
		body.enemy_increase_speed()
		print("DEBUG: enemy entered buff aura. increasing speed: ", body.move_speed)


func _on_buff_area_body_exited(body: Node2D) -> void:
	if body.has_method("is_enemy"):
		body.enemy_revert_speed()
		print("DEBUG: enemy left buff aura. reverting speed: ", body.move_speed)

func is_enemy() -> bool:
	return true
	
func enemy_increase_speed() -> void:
	pass
	
func enemy_revert_speed() -> void:
	pass
