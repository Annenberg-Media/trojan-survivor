extends Node2D

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var label:Label = $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_text_animate(text:String) -> void:
	label.text = text
	animation_player.play("message")
	
	# var start_pos = get_parent().get_parent().get_node("Player").global_position
	var tween = get_tree().create_tween()
	var end_pos = Vector2(0, -100)
	var tween_len = animation_player.get_animation("message").length
	tween.tween_property(self, "position", end_pos, tween_len).from(self.position)

func remove_popup() -> void:
	animation_player.stop()
	if is_inside_tree():
		queue_free()
