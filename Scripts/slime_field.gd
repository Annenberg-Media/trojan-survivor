extends Area2D
class_name SlimeField

var player_ref: Player = null

var lifetime: float = 5

@onready
var animation_player: AnimationPlayer = $AnimationPlayer

static var slow_amount: float = 100

## Active is defined as overlapping with player
## Effect is applied when there is at least one active instance
static var active_instances = []
var is_active: bool = false


func _physics_process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		animation_player.play("fade_away")
		await animation_player.animation_finished
		if is_active:
			SlimeField.remove_active(self)
			is_active = false
		queue_free()
	
	#print("active count: " + str(SlowingField.active_instances.size()))
	print(Player.Instance.movement_speed)
	
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		SlimeField.add_active(self)
		is_active = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		SlimeField.remove_active(self)
		is_active = false
		

static func add_active(item: SlimeField) -> void:
	# only fire first time
	if active_instances.is_empty():
		Player.Instance.movement_speed -= slow_amount
	active_instances.append(item)
	
	
static func remove_active(item: SlimeField) -> void:
	active_instances.erase(item)
	if active_instances.is_empty():
		Player.Instance.movement_speed += slow_amount
