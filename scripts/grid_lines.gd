extends Sprite2D

const GRID_SIZE = 16
var current_position_x: int = GRID_SIZE

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_viewport().size.x:
		var current_line_start: Vector2 = Vector2(current_position_x, 0)
		var current_line_end: Vector2 = Vector2(current_position_x, get_viewport().size.y)
		print("whoops")
		print(current_line_start, current_line_end)
		draw_line(current_line_start, current_line_end, Color.CYAN, 1.0)
		current_position_x += GRID_SIZE

		if current_position_x >= get_viewport().size.x:
			break


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
