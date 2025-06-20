extends Enemy
'''
Behavior:
	- if distance from player greater than some range, move toward player
	- if distance from player falls within some range, circle around playr, 
	dropping wood_dam objects along path
	- if distance from player below range, run away from player 
'''

@onready var player = get_tree().get_current_scene().get_node("Player")
@onready var timer = $DamTimer
var wood_dam = preload("res://Scenes/wood_dam.tscn")
var direction: Vector2
var movespeed = 150
var state = 0  # 0 for move toward, 1 for circle around, 2 for run away
	
func _physics_process(delta: float) -> void:
	var distance_from_player = (position - player.position).length()
	
	if distance_from_player > 400:
		timer.stop()
		direction = (player.position - position).normalized()
	elif distance_from_player <= 400 and distance_from_player >= 300:
		if timer.is_stopped():
			timer.start()
		direction = Vector2(-1*(player.position - position).y, (player.position - position).x).normalized()
	else:
		timer.stop()
		direction = (position - player.position).normalized()
		
	velocity = direction * movespeed
	move_and_slide()


func _on_dam_timer_timeout() -> void:
	var dam_place_pos = global_position + (-direction*90)
	var new_dam = wood_dam.instantiate()
	get_tree().current_scene.add_child(new_dam)
	new_dam.position = dam_place_pos
