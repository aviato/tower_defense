extends Node


signal castle_damaged(castle_health)
signal gold_changed(current_gold)
signal purchase_failed(reason)

@export var gold: int = 500:
	set = set_gold
@export var castle_health := 1000:
	set = set_castle_health
@export var _current_wave: int = 0
@export var _wave_active: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
	
func set_castle_health(damage: int) -> void:
	var new_castle_health := castle_health - damage
	castle_health = new_castle_health
	castle_damaged.emit(castle_health)


func set_gold(new_gold_amount: int) -> void:
	gold = new_gold_amount
	gold_changed.emit(new_gold_amount)


func add_gold(gold_amount: int) -> void:
	set_gold(gold + gold_amount)


func spend_gold(gold_amount: int) -> void:
	var new_gold_amount := gold - gold_amount
	set_gold(new_gold_amount)


func has_enough_gold(gold_amount: int) -> bool:
	if gold - gold_amount >= 0:
		return true
	else:
		purchase_failed.emit("Not enough gold.")
		return false


func next_wave():
	_current_wave += 1


func start_round():
	_wave_active = true
	

func end_round():
	_wave_active = false





