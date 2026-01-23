extends Node2D

const lines: Array[String] = [
	"Welcome to Trojan Survivors, where you'll play as Tommy Trojan, awakened to defend the USC campus from an endless onslaught of mascot characters!",
	"Use the WASD keys to move and the LEFT MOUSE BUTTON to throw objects!", 
	"Try hitting this enemy with an object!"
]

@onready var dialogue_manager = get_node("../DialogueManager")

func _ready() -> void:
	dialogue_manager.start_dialogue(global_position, lines)
