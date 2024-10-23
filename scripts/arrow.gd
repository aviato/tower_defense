extends Area2D


@onready var sprite: Sprite2D = $Sprite2D
var _direction := Vector2.ZERO
var _velocity := Vector2.ZERO
var target: CharacterBody2D = null
var _arrow_speed := 333.0
var _hit_target: bool
var _is_flying: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if target == null and _is_flying:
		queue_free()
		return

	if target != null and not _hit_target:
		var next_direction = target.global_position - global_position
		_direction = next_direction.normalized()
		_velocity = _direction * _arrow_speed * delta
		rotation = _direction.angle()
		sprite.flip_h = next_direction.x < 0
		global_position += _velocity


func set_hit_target():
	_hit_target = true
	_is_flying = false
	queue_free()

func set_target(body: CharacterBody2D, arrow_speed: float) -> void:
	target = body
	_is_flying = true
	_arrow_speed = arrow_speed
