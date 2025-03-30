extends CanvasLayer

@onready var GameManager = $"../../GameManager"

@onready var score_label = $MarginContainer/HBoxContainer/VBoxContainer/Score
@onready var time_label = $MarginContainer/HBoxContainer/VBoxContainer/Time

func _ready() -> void:
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.time_changed.connect(_on_time_changed)

func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score

func _on_time_changed(new_time: float) -> void:
	var minutes = floor(new_time / 60)
	var seconds = fmod(new_time, 60)
	time_label.text = "Time: %02d:%02d" % [minutes, seconds]
