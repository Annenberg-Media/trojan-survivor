extends MeleeEnemy

var slime_scene = preload("res://Scenes/slime_field.tscn")

static var slime_drop_interval: float = 2
@onready var slug_sprite = $AnimatedSprite2D

func _ready() -> void:
	super._ready()
	var offset_timer: Timer = Timer.new()
	add_child(offset_timer)
	offset_timer.start(randf_range(0,1))
	await offset_timer.timeout
	$SlimeDropTimer.start(slime_drop_interval)

	
func _on_slime_drop_timer_timeout() -> void:
	var new_slime: Node2D = slime_scene.instantiate()
	new_slime.global_position = global_position
	new_slime.rotate(randf_range(0, TAU))
	GameManager.Instance.slime_fields.add_child(new_slime)
