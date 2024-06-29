extends CharacterBody2D

## Enemy AI script that deals with an enemy characters state and animations
## In order for the script to work correctly it must be attached to the root
## of a scene with the following Node tree
##
## CharacterBody2D
## ├── AnimatedSprite2D
## ├── Hitbox (CollisionShape2D)
## └── AggroRadius (Area2D)
##    └── CollisionShape2D
## 
## Assets should only have three directions: s, u, d, which correspond to
## sideways, up, and down
## 
## Animation names should always be snake case ex: "walk_s", "attack_u"

@export var _speed: float = 50.0
@export var _health: int = 100
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _aggro_radius = $AggroRadius
@onready var _hitbox = $Hitbox
var _is_attacking: bool = false

func _ready():
	_animated_sprite.connect("animation_finished", _on_animation_finished)


func _physics_process(delta) -> void:
	var target_position: Vector2 = get_target_position()
	var direction: Vector2 = (target_position - global_position).normalized()
	var velocity = direction * _speed
	var orientation = get_orientation(direction) # NOTE: also flips the sprite!
	var state: String = ""

	if _health <= 0:
		state = "die"
	elif _is_attacking:
		state = "attack"
	else:
		state = "walk"

	animate(state, orientation)

	var collision: KinematicCollision2D = move_and_collide(velocity * delta)

	if collision:
		velocity = Vector2.ZERO


func _on_animation_finished():
	# TODO: this should not be called on every animation finish signal!
	# it should really only run when the die animation finishes
	if _health <= 0:
		queue_free()


func get_target_position():
	if true:
		return Vector2(get_viewport().size.x / 2, 0)


func get_orientation(direction: Vector2):
	var orientation: String = ""

	if abs(direction.x) > abs(direction.y):
		orientation = "s"
		if (direction.x > 0):
			_animated_sprite.flip_h = true
		else:
			_animated_sprite.flip_h = false
	else:
		if direction.y < 0:
			orientation = "u"
		else:
			orientation ="d"

	return orientation


func animate(state: String, orientation: String) -> void:
	var sprite_frames: SpriteFrames = _animated_sprite.sprite_frames
	var next_animation: String = state + "_" + orientation
	assert(sprite_frames.has_animation(next_animation))
	_animated_sprite.play(next_animation)


func get_character_state() -> String:
	print(_health)
	if _health <= 0:
		return "die"
	elif _is_attacking:
		return "attack"
	else:
		return "walk"


func _on_aggro_radius_body_entered(body):
	var distance_between: Vector2 = (body.global_position - global_position).normalized()
	if abs(distance_between.x) + abs(distance_between.y) > 1:
		_is_attacking = true

