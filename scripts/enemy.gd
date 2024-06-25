extends CharacterBody2D

@export var speed: float = 50.0
@export var health: int = 100
@onready var last_global_position: Vector2 = global_position
@onready var animated_sprite = $AnimatedSprite2D
@onready var aggro_radius = $AggroRadius
@onready var hitbox = $CollisionShape2D

func _ready():
	pass


func _physics_process(delta) -> void:
	var target_position: Vector2 = get_target_position()
	var direction: Vector2 = (target_position - global_position).normalized()
	var velocity = direction * speed
	var orientation = get_orientation(direction)
	var state = get_character_state()

	animate(state, orientation)
	
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if collision:
		velocity = Vector2.ZERO

	last_global_position = global_position


func get_target_position():
	if true:
		return Vector2(get_viewport().size.x / 2, 0)
	

func move():
	pass


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

