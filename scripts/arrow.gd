extends Area2D


@onready var sprite: Sprite2D = $Sprite2D
var _direction := Vector2.ZERO
var _velocity := Vector2.ZERO
var _target: CharacterBody2D = null
var _arrow_speed := 333.0


# Called when the node enters the scene tree for the first time.
func _ready():
	print("arrow ready!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _target != null:
		var next_direction = _target.global_position - global_position
		_direction = next_direction.normalized()
		_velocity = _direction * _arrow_speed * delta
		rotation = _direction.angle()
		sprite.flip_h = next_direction.x < 0
		global_position += _velocity

		if global_position.distance_to(_target.global_position) < 1:
			#print("hit target!")
			queue_free()


func set_target(target: CharacterBody2D, arrow_speed: float) -> void:
	_target = target
	_arrow_speed = arrow_speed

