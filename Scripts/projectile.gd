extends Area2D
class_name Projectile

@export
## speed in pixels per second
var speed: float = 500

var direction: Vector2 = Vector2.ZERO

## lifetime to auto free stray bullets
var lifetime: float = 10
var sprite_num 
var projectile_sprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	projectile_sprite = $AnimatedSprite2D
	sprite_num = str(randi_range(1, 9))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	projectile_sprite.play(sprite_num)
	rotation += 3*delta
	global_position += direction * (speed * delta)
	lifetime -= delta
	if lifetime < 0:
		queue_free()
		

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		if body.has_method("tank_hit"):
			if body.tank_hit():
				queue_free()
				return
		body.on_death()
		queue_free()
