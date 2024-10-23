extends StaticBody2D


@onready var global_state := $"/root/Globals" as Globals


func _ready():
	pass # Replace with function body.


func _process(_delta):
	pass
	
func take_damage(damage_amount: int) -> void:
	global_state.set_castle_health(damage_amount)
