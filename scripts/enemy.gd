extends CharacterBody2D
## Enemy AI script that deals with an enemy characters state and animations
## In order for the script to work correctly it must be attached to the root
## of a scene with the following Node tree
##
## CharacterBody2D (Ex: "Orc")
## ├── AnimatedSprite2D
## ├── Hitbox (CollisionShape2D)
## └── AggroRadius (Area2D)
##    └── CollisionShape2D
## 
## Assets should only have three directions: s, u, d, which correspond to
## sideways, up, and down
## 
## Animation names should always be snake case ex: "walk_s", "attack_u"

@export var speed: float = 50.0
@export var health: int = 100
@onready var last_global_position: Vector2 = global_position
@onready var animated_sprite = $AnimatedSprite2D
@onready var aggro_radius = $AggroRadius
@onready var hitbox = $Hitbox

func _ready():
	pass


func _physics_process(delta) -> void:
	var target_position: Vector2 = get_target_position()
	var direction: Vector2 = (target_position - global_position).normalized()
	var velocity = direction * speed
	var orientation = get_orientation(direction) # NOTE: also flips the sprite!
	var state = get_character_state()

	animate(state, orientation)

	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if collision:
		velocity = Vector2.ZERO

	last_global_position = global_position


func get_target_position():
	if true:
		return Vector2(get_viewport().size.x / 2, 0)


func get_orientation(direction: Vector2):
	var orientation: String = ""

	if abs(direction.x) > abs(direction.y):
		orientation = "s"
		if (direction.x > 0):
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	else:
		if direction.y < 0:
			orientation = "u"
		else:
			orientation ="d"
	
	return orientation


func animate(state: String, orientation: String) -> void:
	var sprite_frames: SpriteFrames = animated_sprite.sprite_frames
	var next_animation: String = state + "_" + orientation
	assert(sprite_frames.has_animation(next_animation))
	animated_sprite.play(next_animation)


func get_character_state() -> String:
	return "walk"

