extends Node2D

const GRID_SIZE = Vector2(16, 16)

# Called when the node enters the scene tree for the first time.
func _draw():
	for x in range(0, get_viewport_rect().size.x, GRID_SIZE.x):
		draw_line(Vector2(x, 0), Vector2(x, get_viewport_rect().size.y), Color.DARK_KHAKI)

	for y in range(0, get_viewport_rect().size.y, GRID_SIZE.y):
		draw_line(Vector2(0, y), Vector2(get_viewport_rect().size.x, y), Color.DARK_KHAKI)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
