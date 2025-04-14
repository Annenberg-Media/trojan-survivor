extends Resource
class_name UpgradeData

@export
var upgrade_name: String = ""

@export
var icon: Texture2D = null

@export_multiline
var description: String = ""

@export
var effect: Effect = null

func _to_string() -> String:
	return "Upgrade: " + upgrade_name
