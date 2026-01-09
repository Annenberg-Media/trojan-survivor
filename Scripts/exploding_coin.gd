extends Area2D
class_name ExplodingCoin

'''
@export var explosion_damage: int = 20
@export var explosion_radius: float = 100.0
@export var explode_time: float = 2.5

var has_exploded = false
'''

@onready var animated_sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var exploding_duration:Timer = $ExplosionDuration
@onready var player:Player = get_parent().get_node("Player")


# 0: default, 1: charging, 2: exploding
var state:int
var player_inside:bool

func _ready():
	'''
	collision_mask = 1 
	
	# Timer until explode 
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = explode_time
	timer.one_shot = true
	timer.timeout.connect(explode)
	timer.start()
	'''
	state = 0
	player_inside = false
	animated_sprite.play("default")
	
func _process(delta: float) -> void:
	if self.get_overlapping_bodies().has(player) and state == 2:
		# print("DEBUG: explosion ongoing and player inside")
		player.receive_hit()

func explode():
	'''
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
	'''
	# set state to 2
	# play exploding animation
	state = 2
	animated_sprite.scale = Vector2(4, 4)
	animated_sprite.play("explode")
	exploding_duration.start()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_inside = true
		if state == 0:
			# set state to 1
			# play charge animation
			# wait for it
			# call explode() function and return
			state = 1
			animated_sprite.play("charge")
			await animated_sprite.animation_finished
			explode()
		elif state == 2:
			print("coin exploding, player takes damage")
			body.receive_hit()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_inside = false

func _on_explosion_duration_timeout() -> void:
	queue_free()
