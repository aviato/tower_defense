extends Node2D

const GRID_SIZE = Vector2(16, 16)
#var current_position_x: int = GRID_SIZE
#var current_position_y: int = GRID_SIZE

# Called when the node enters the scene tree for the first time.
func _draw():
	for x in range(0, get_viewport_rect().size.x, GRID_SIZE.x):
		draw_line(Vector2(x, 0), Vector2(x, get_viewport_rect().size.y), Color.DARK_KHAKI)

	for y in range(0, get_viewport_rect().size.y, GRID_SIZE.y):
		draw_line(Vector2(0, y), Vector2(get_viewport_rect().size.x, y), Color.DARK_KHAKI)
		
	#print(get_viewport().size)
	#for i in get_viewport().size.x:
		#
		#if current_position_x >= get_viewport().size.x:
			#break
		#
		#var x_line_start: Vector2 = Vector2(current_position_x, 0)
		#var x_line_end: Vector2 = Vector2(current_position_x, get_viewport().size.y)
		##print(current_line_start, current_line_end)
		#draw_line(x_line_start, x_line_end, Color.CYAN, 1.0)
		#
	#for j in get_viewport().size.y:
		#var y_line_start: Vector2 = Vector2(0, current_position_y)
		#var y_line_end: Vector2 = Vector2(0, get_viewport().size.x)
		#print(y_line_start, y_line_end)
		#draw_line(y_line_start, y_line_end, Color.CYAN, 1.0)
#
	#if current_position_y >= get_viewport().size.y:
				#break
#
#
#
		#current_position_y += GRID_SIZE
		#current_position_x += GRID_SIZE



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
