extends Node

var score = 0

func add_score(amount):
	score += amount
	print("Score: ", score)

func reset():
	score = 0
