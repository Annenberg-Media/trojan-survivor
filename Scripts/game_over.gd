extends Node2D

@onready 
var player = get_node("/root/Game/Player")
# @onready var game_over_ui = get_node("/root/Game/")

func _ready():
	player.game_over.connect(when_game_over)

func when_game_over():
	# enable ui visibility here and display score
	# game_over_ui.visible = true
	get_tree().paused = true
