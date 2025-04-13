extends Sprite2D
class_name Crosshair

@export
var inner_radius: float = 16
@export
var outer_radius: float = 32
@export
var ring_color: Color = Color.GREEN

var current_angle: float = 0

@onready
var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	queue_redraw()

func _draw() -> void:
	draw_ring(Vector2.ZERO, -PI/2, -PI/2 + current_angle, ring_color)

func draw_ring(center, start_angle, end_angle, color):
	var arc = PackedVector2Array()
	var colors = PackedColorArray([color])
	for i in range(64 + 1):
		var angle: float = start_angle
		angle += i * (end_angle - start_angle) / 64
		arc.push_back(center + outer_radius * Vector2(cos(angle), sin(angle)))
		
	for i in range(64, -1, -1):
		var angle: float = start_angle
		angle += i * (end_angle - start_angle) / 64
		arc.push_back(center + inner_radius * Vector2(cos(angle), sin(angle)))
	
	draw_polygon(arc, colors)

func shoot_effect():
	animation_player.stop()
	animation_player.play("crosshair_click")
