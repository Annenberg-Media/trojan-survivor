extends Area2D
class_name ExplodingCoin

@export var explosion_damage: int = 20
@export var explosion_radius: float = 100.0
@export var explode_time: float = 2.5

var has_exploded = false

func _ready():
	collision_mask = 1 
	
	# Timer until explode 
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = explode_time
	timer.one_shot = true
	timer.timeout.connect(explode)
	timer.start()

func explode():
	# Explode once after time
	if has_exploded:
		return
		
	has_exploded = true
	# print("Coin exploded.")
	
	# Circle of explosion + raidius
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = explosion_radius
	query.shape = circle_shape
	query.transform = global_transform
	query.collision_mask = 1 
	
	var results = space_state.intersect_shape(query)
	
	# Damage player
	for result in results:
		var body = result["collider"]
		
		if body.name == "Player" or (body.has_method("is_player") and body.is_player()):
			if body.has_method("receive_hit"):
				body.receive_hit(explosion_damage)
				print("Player took ", explosion_damage, " damage from explosion.")
				break 
	
	queue_free()
