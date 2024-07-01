extends Node2D
# Player script holds game logic related to placing towers and other
# actions a player may take during the course of a game

@onready var archer_tower_scene: PackedScene = preload("res://scenes/archer_tower.tscn")
@onready var placeholder_valid: Node2D = $PlaceholderArea/PlaceholderValid
@onready var placeholder_invalid: Node2D = $PlaceholderArea/PlaceholderInvalid
@onready var game_scene: Node = $/root/Main/Game #TODO: is Node correct here during run-time?
@onready var _global_state: Node = $"/root/Globals"
var _is_placing_tower: bool = false
var _is_valid_placement: bool = false


func _ready():
	pass


func _process(_delta) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	if _is_placing_tower:
		$PlaceholderArea.position = mouse_pos


func _input(event: InputEvent) -> void:
	if _is_placing_tower and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var mouse_pos: Vector2 = event.position
			place_tower(mouse_pos)


func place_tower(tower_pos: Vector2) -> void:
	if _is_valid_placement:
		var new_tower = archer_tower_scene.instantiate() #TODO: add type here
		new_tower.global_position = tower_pos
		game_scene.add_child(new_tower)
		placeholder_valid.visible = false
		placeholder_invalid.visible = false
		_is_placing_tower = false


func _on_place_tower_button_pressed():
	_is_placing_tower = !_is_placing_tower

	if !_is_placing_tower:
		placeholder_valid.visible = false
		placeholder_invalid.visible = false
	else:
		placeholder_valid.visible = true


func _on_placeholder_area_entered(area):
	_is_valid_placement = false
	placeholder_invalid.visible = true
	placeholder_valid.visible = false


#TODO fix _is_valid_placement bug
# currently we flip _is_valid_placement to true no matter what
# if user's mouse leaves an area considered to be off-limits
# but the mouse is still in an off-limits area we will have toggled
# the placeholder sprite incorrectly
func _on_placeholder_area_exited(area):
	_is_valid_placement = true
	placeholder_valid.visible = true
	placeholder_invalid.visible = false

