extends Node


@export var _castle_health: int = 1000
@export var _current_wave: int = 0
@export var _wave_active: bool = false
@export var _current_gold: int = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func set_castle_health(damage: int) -> void:
	_castle_health -= damage


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



