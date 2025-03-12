extends Area2D

@export
## speed in pixels per second
var speed: float = 400

var direction: Vector2 = Vector2.ZERO

## lifetime to auto free stray bullets
var lifetime: float = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## sprite randomization
	$Sprite2D.modulate = Color(1, 0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += direction * (speed * delta)
	lifetime -= delta
	if lifetime < 0:
		queue_free()
		

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("is_player"):
		# TO BE CHANGED when player health implemented 
		print("Player hit by enemy projectile!")
		queue_free()
