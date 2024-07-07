extends Node2D
# Game script holds game logic related to placing towers and other
# actions a player may take during the course of a game
const GRID_SIZE = Vector2(16, 16)
@export var _current_wave: int = 0
@export var _wave_active: bool = false
@export var _current_gold: int = 500
var _is_placing_tower: bool = false
var _is_valid_placement: bool = false
var _colliding_bodies: Array[Area2D] = []
var _is_game_over = false:
	set = _set_is_game_over
@onready var archer_tower_scene: PackedScene = preload("res://scenes/archer_tower.tscn")
@onready var placeholder_valid: Node2D = $BuildArea/PlaceholderValid
@onready var placeholder_invalid: Node2D = $BuildArea/PlaceholderInvalid
@onready var orc_scene: PackedScene = preload("res://scenes/orc.tscn")
@onready var global_state: Node = $"/root/Globals"
@onready var build_grid: Node2D = $BuildGrid


func _ready() -> void:
	global_state.castle_damaged.connect(_set_is_game_over)

	for i in 10:
		var orc: CharacterBody2D = orc_scene.instantiate()
		#orc.attacked.connect()
		add_child(orc)


func _process(_delta) -> void:
	if _is_game_over:
		print("game over bud...")
		return

	var mouse_pos: Vector2 = get_global_mouse_position()
	
	if _is_placing_tower:
		$BuildArea.position = snap_vector(mouse_pos)


func _input(event: InputEvent) -> void:
	if _is_placing_tower and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var mouse_pos: Vector2 = event.position
			place_tower(mouse_pos)


func _set_is_game_over(castle_health: int) -> void:
	print("castle health is ", castle_health)
	if castle_health <= 0:
		_is_game_over = true
	else:
		_is_game_over = false

#NOTE I do not know how this works
func snap_vector(pos: Vector2):
	return Vector2(
		int(pos.x / GRID_SIZE.x) * GRID_SIZE.x,
		int(pos.y / GRID_SIZE.y) * GRID_SIZE.y
	)


func place_tower(tower_pos: Vector2) -> void:
	if _is_valid_placement:
		var new_tower = archer_tower_scene.instantiate() #TODO: add type here
		new_tower.global_position = snap_vector(tower_pos)
		add_child(new_tower)
		placeholder_valid.visible = false
		placeholder_invalid.visible = false
		build_grid.visible = false
		_is_placing_tower = false


func _on_place_tower_button_pressed() -> void:
	_is_placing_tower = !_is_placing_tower
	build_grid.visible = true

	if !_is_placing_tower:
		placeholder_valid.visible = false
		placeholder_invalid.visible = false
	else:
		placeholder_valid.visible = true


func _on_placeholder_area_entered(area: Area2D) -> void:
	_colliding_bodies.append(area)
	_is_valid_placement = false
	placeholder_valid.visible = false
	
	if _is_placing_tower:
		placeholder_invalid.visible = true


func _on_placeholder_area_exited(area: Area2D) -> void:
	var area_index: int = _colliding_bodies.find(area) 
	if area_index != -1:
		_colliding_bodies.remove_at(area_index)
	
	if _colliding_bodies.size() == 0:
		_is_valid_placement = true
		placeholder_valid.visible = true
		placeholder_invalid.visible = false


func next_wave():
	_current_wave += 1


func start_round():
	_wave_active = true


func end_round():
	_wave_active = false


func add_gold(gold_amount: int) -> void:
	_current_gold += gold_amount


func remove_gold(gold_amount: int) -> void:
	_current_gold -= gold_amount


func has_enough_gold(gold_amount: int) -> bool:
	return _current_gold - gold_amount >= 0

#func pick_random_location():
	#var rng = RandomNumberGenerator.new()
	#rng.randomize()
	#
	#var random_x = rng.randf_range(top_left.x + enemy_size.x / 2, bottom_right.x - enemy_size.x / 2)
	#var random_y = rng.randf_range(top_left.y + enemy_size.y / 2, bottom_right.y - enemy_size.y / 2)
	#
	#return Vector2(random_x, random_y)
