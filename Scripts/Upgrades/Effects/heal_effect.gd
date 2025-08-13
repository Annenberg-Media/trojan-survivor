extends Effect
class_name HealEffect

@export
var amount: int = 1

## Resource object that holds different scripts for effects
func apply_effect(player: Player):
	print("Increased player movement speed by 25")
	player.heal_health(amount)

func undo_effect(player: Player):
	return
