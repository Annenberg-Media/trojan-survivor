extends Effect
class_name SpeedIncreaseEffect

@export
var amount: float = 25

## Resource object that holds different scripts for effects
func apply_effect(player: Player):
	print("Increased player movement speed by 25")
	player.movement_speed += amount

func undo_effect(player: Player):
	print("Decreased player movement speed by 25")
	player.movement_speed -= amount
	
