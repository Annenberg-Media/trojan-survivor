extends MeleeEnemy

'''
Behavior:
	- when outside of range, "stalks" player at slower speed
	- once within certain range, will start charging up
	a "lunge" attack
'''
var walk_speed: int = 70
var move_direction: Vector2
var attack_direction: Vector2
var lock_on_radius: int = 200
var attack_in_progress: bool = false

@onready var lunge_chargeup = $LungeChargeUp
@onready var attacking_timer = $AttackingTimer
@onready var curr_state: int = State.stalking
@onready var tiger_sprite := get_node_or_null("AnimatedSprite2D")

enum State
{
	stalking, 
	charging, 
	lunging
}

func _physics_process(delta: float) -> void:
	if player.global_position.x > global_position.x:
		tiger_sprite.flip_h = true
	else:
		tiger_sprite.flip_h = false
	match curr_state:
		State.stalking:
			tiger_sprite.play("walk")
			move_direction = (player.position - position).normalized()
			walk_speed = 70
			if (player.position - position).length() <= 300 and curr_state == State.stalking:
				attack_direction = player.position
				tiger_attack()
		
		State.charging:
			tiger_sprite.play("prepare")
			walk_speed = 0
			
		State.lunging:
			tiger_sprite.play("attack")
			move_direction = (attack_direction - position).normalized()
			walk_speed = 500
			
			if (attack_direction - position).length() < 10:
				curr_state = State.stalking
				walk_speed = 70
	
	velocity = move_direction * walk_speed
	move_and_slide()

func tiger_attack() -> void:
	curr_state = State.charging
	# print("DEBUG: Tiger within range; attacking position: (", player_pos.x, ",", player_pos.y, ")")
	lunge_chargeup.start()

func _on_lunge_charge_up_timeout() -> void:
	curr_state = State.lunging
