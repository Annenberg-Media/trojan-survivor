extends Enemy

@onready var player = get_node("/root/Game/Player")

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if player:
		var direction = (player.position - position).normalized()
		velocity = direction * 85
		move_and_slide()
		
func is_enemy():
	return true
