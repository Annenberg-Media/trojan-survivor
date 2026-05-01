extends Node2D

@onready var text = $RichTextLabel
var final_score:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text.text = str(final_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
