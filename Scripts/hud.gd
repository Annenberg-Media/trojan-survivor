extends CanvasLayer

@onready var health_label = $MarginContainer/HBoxContainer/VBoxContainer/Health
@onready var score_label = $MarginContainer/HBoxContainer/VBoxContainer/Score
@onready var time_label = $MarginContainer/HBoxContainer/VBoxContainer/Time

func _ready() -> void:
	Player.Instance.health_changed.connect(_on_health_changed)
	# call to update to initial value
	_on_health_changed(Player.Instance.current_health)

func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score

func _on_time_changed(new_time: float) -> void:
	var minutes = floor(new_time / 60)
	var seconds = fmod(new_time, 60)
	time_label.text = "Time: %02d:%02d" % [minutes, seconds]

func _on_health_changed(new_health: int) -> void:
	health_label.text = "Health: " + str(new_health)
