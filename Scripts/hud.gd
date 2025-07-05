extends CanvasLayer

@onready var health_label = $MarginContainer/HBoxContainer/VBoxContainer/Health
@onready var health_display: HealthDisplay = %HealthDisplay

@onready var score_label = $MarginContainer/HBoxContainer/VBoxContainer/Score
@onready var time_label = $MarginContainer/HBoxContainer/VBoxContainer/Time
@onready var exp_label = $MarginContainer/HBoxContainer/VBoxContainer/EXP

@onready var upgrade_menu = $UpgradeMenu
@onready var upgrade_option_buttons_container: Control = $UpgradeMenu/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer

signal upgrade_selected(index: int)


func _ready() -> void:
	Player.Instance.health_changed.connect(_on_health_changed)
	Player.Instance.exp_changed.connect(_on_exp_changed)
	# call to update to initial value
	_on_health_changed(Player.Instance.current_health)
	_on_exp_changed(Player.Instance.exp_amount, Player.Instance.exp_per_level)

func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score

func _on_time_changed(new_time: float) -> void:
	var minutes = floor(new_time / 60)
	var seconds = fmod(new_time, 60)
	time_label.text = "Time: %02d:%02d" % [minutes, seconds]

func _on_health_changed(new_health: int) -> void:
	health_label.text = "Health: " + str(new_health)
	health_display.set_count(new_health)

func _on_exp_changed(new_exp: int, max_amount: int) -> void:
	exp_label.text = "EXP: " + str(new_exp) + "/" + str(max_amount)
	
func show_upgrade_menu(options: Array) -> void:
	if options == null:
		push_error("upgrade option list null")
		return
		
	upgrade_menu.visible = true
	for i in range(upgrade_option_buttons_container.get_child_count()):
		var button: UpgradeOptionButton = upgrade_option_buttons_container.get_child(i)
		if i < options.size():
			var cur_option: UpgradeData = options[i]
			button.name_label.text = cur_option.upgrade_name
			button.description_label.text = cur_option.description
			button.upgrade_icon.texture = cur_option.icon
			
			if !button.option_selected.is_connected(_on_upgrade_option_button_pressed):
				button.option_selected.connect(_on_upgrade_option_button_pressed)

func _on_upgrade_option_button_pressed(index: int) -> void:
	upgrade_selected.emit(index)
	upgrade_menu.visible = false
