extends CharacterBody2D

## Enemy AI script that deals with an enemy characters state and animations
## In order for the script to work correctly it must be attached to the root
## of a scene with the following Node tree
##
## CharacterBody2D
## ├── AnimatedSprite2D
## ├── Hitbox (CollisionShape2D)
## ├── NavigationAgent2D
## └── AggroRadius (Area2D)
##    └── CollisionShape2D
## 
## Assets should only have three directions: s, u, d, which correspond to
## sideways, up, and down
## 
## Animation names should always be snake case ex: "walk_s", "attack_u"

@export var _move_speed: float = 5.0
@export var _health: int = 100

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var _enemy_destination: Area2D = get_node("/root/Main/Game/EnemyDestination")

var _is_attacking: bool = false

func _ready() -> void:
	_animated_sprite.connect("animation_finished", _on_animation_finished)
	_nav_agent.path_desired_distance = 4.0
	_nav_agent.target_desired_distance = 4.0


func _physics_process(_delta: float) -> void:
	if _nav_agent.is_navigation_finished():
		return
	
	var next_path_position: Vector2 = _nav_agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * _move_speed
	var orientation = get_orientation(next_path_position) # NOTE: also flips the sprite!
	
	# NOTE: also controls character state
	animate(orientation)
	
	if _nav_agent.avoidance_enabled:
		_nav_agent.set_velocity(new_velocity)
	else:
		_on_nav_agent_velocity_computed(new_velocity)


func _on_animation_finished() -> void:
	# TODO: this should not be called on every animation finish signal!
	# it should really only run when the die animation finishes
	if _health <= 0:
		queue_free()

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
	

func animate(orientation: String) -> void:
	var state = "walk"
	if _health <= 0:
		state = "die"
	elif _is_attacking:
		state = "attack"

	var sprite_frames: SpriteFrames = _animated_sprite.sprite_frames
	var next_animation: String = state + "_" + orientation
	assert(sprite_frames.has_animation(next_animation))
	_animated_sprite.play(next_animation)


func _on_aggro_radius_body_entered(body) -> void:
	var distance_between: Vector2 = (body.global_position - global_position).normalized()
	if abs(distance_between.x) + abs(distance_between.y) > 1:
		_is_attacking = true


func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	print('safe_velocity = ', safe_velocity)
	velocity = safe_velocity
	print(velocity)
	move_and_slide()

