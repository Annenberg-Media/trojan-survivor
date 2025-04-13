extends CanvasLayer

@onready var health_label = $MarginContainer/HBoxContainer/VBoxContainer/Health
@onready var score_label = $MarginContainer/HBoxContainer/VBoxContainer/Score
@onready var time_label = $MarginContainer/HBoxContainer/VBoxContainer/Time

@onready var upgrade_menu = $UpgradeMenu
@onready var upgrade_option_buttons_container: Control = $UpgradeMenu/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer

signal upgrade_selected(index: int)


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

func show_upgrade_menu() -> void:
	upgrade_menu.visible = true
	for button: Button in upgrade_option_buttons_container.get_children():
		# connect button to self's function if not connected already
		if !button.option_selected.is_connected(_on_upgrade_option_button_pressed):
			button.option_selected.connect(_on_upgrade_option_button_pressed)

func _on_upgrade_option_button_pressed(index: int) -> void:
	upgrade_selected.emit(index)
	upgrade_menu.visible = false
