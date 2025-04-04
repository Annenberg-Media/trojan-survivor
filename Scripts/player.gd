extends CharacterBody2D
class_name Player

static var Instance: Player

@export
var current_health: int = 3
var _max_health: int = 3
var health_overload: int = 0

@onready
var crosshair: Node2D = $Crosshair
var bullet_prefab: PackedScene = preload("uid://pe8pcbqp47dd")
var shoot_cooldown_timer: Timer
@export
var shooting_cooldown_amount: float = 0.2

@export
## player's movement speed in pixels per second
var movement_speed: float = 200
@onready
var movement_dust_particle: CPUParticles2D = $MovementDustParticle

@onready
var animation_player: AnimationPlayer = $AnimationPlayer

var exp_amount: int = 0
var _exp_per_level: int = 1000

signal game_over
signal health_changed(amount: int)


func _ready() -> void:
	if Player.Instance == null:
		Player.Instance = self
		
	shoot_cooldown_timer = Timer.new()
	shoot_cooldown_timer.autostart = false
	shoot_cooldown_timer.one_shot = true
	shoot_cooldown_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	add_child(shoot_cooldown_timer)
	
	
func _physics_process(delta: float) -> void:
	var move_dir: Vector2 = Vector2.ZERO
	# W - up
	if Input.is_action_pressed("move_up"):
		move_dir += Vector2.UP
	# A - left
	if Input.is_action_pressed("move_left"):
		move_dir += Vector2.LEFT
	# S - down
	if Input.is_action_pressed("move_down"):
		move_dir += Vector2.DOWN
	# D - right
	if Input.is_action_pressed("move_right"):
		move_dir += Vector2.RIGHT
	move_dir = move_dir.normalized()
	
	global_position += move_dir * (movement_speed * delta)
	
	# emit movement_dust_particle if we are moving
	movement_dust_particle.emitting = move_dir != Vector2.ZERO
	
	if Input.is_action_just_pressed("shoot"):
		shoot_projectile(global_position.direction_to(crosshair.global_position))


func shoot_projectile(dir: Vector2):
	# shooting is on cooldown
	if !shoot_cooldown_timer.is_stopped():
		print("Shooting on cooldown")
		return
		
	var new_projectile: Projectile = bullet_prefab.instantiate()
	new_projectile.global_position = global_position
	new_projectile.direction = dir
	get_tree().root.add_child(new_projectile)
	shoot_cooldown_timer.start(shooting_cooldown_amount)
	
func is_player():
	return true

func receive_hit(amount: int = 1):
	current_health -= amount
	health_changed.emit(current_health)
	animation_player.play("hit_blink")
	
	# if there is more health in our overload
	if health_overload > 0:
		current_health += health_overload
		if current_health > _max_health:
			health_overload = current_health - _max_health
			current_health = _max_health
	elif current_health <= 0:
		print("PLAYER HEALTH IS ZERO")
		game_over.emit()
		
func get_max_health() -> int:
	return _max_health

func add_exp(amount: int) -> void:
	exp_amount += amount
	print("Added " + str(amount) + " EXP. Current: " + str(exp_amount))
	if exp_amount > _exp_per_level:
		print("Level up!")
		exp_amount -= _exp_per_level

func on_level_up() -> void:
	# choose upgrade option
	pass
