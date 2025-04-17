extends Effect
class_name AttackSpeedIncreaseEffect

@export
var amount: float = 0.1

## Resource object that holds different scripts for effects
func apply_effect(player: Player):
	print("Decrease player attack cooldown by 10%")
	player.shooting_cooldown_amount *= 1 - amount
