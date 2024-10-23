extends CharacterBody2D
## Enemy AI script that deals with an enemy characters state and animations
## In order for the script to work correctly it must be attached to the root
## of a scene with the following Node tree
##
## CharacterBody2D
## ├── AnimatedSprite2D
## ├── Collider (CollisionShape2D)
## ├── NavigationAgent2D
## └── AggroRadius (Area2D)
##    └── CollisionShape2D
## └── Hitbox (Area2D)
##    └── CollisionShape2D
## 
## Assets should only have three directions: s, u, d, which correspond to
## sideways, up, and down
## 
## Animation names should always be snake case ex: "walk_s", "attack_u"
signal attacked(damage_amount)
signal dropped_gold(gold_amount)

@export var _move_speed := 55.0
@export var _health := 100
@export var _character_state := "walk"
var _is_attacking := false
var _attack_power := 20
var _gold_in_pockets := 50
@onready var _animated_sprite := $AnimatedSprite2D as AnimatedSprite2D
@onready var _nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var _enemy_destination := get_node("/root/Main/Game/EnemyDestination") as Area2D
@onready var _global_state := $/root/Globals as Globals
@onready var _progress_bar := $ProgressBar as ProgressBar

func _ready() -> void:
	_animated_sprite.animation_finished.connect(_on_animation_finished)
	$ProgressBar.value = _health
	call_deferred("_nav_agent_setup")


func _physics_process(_delta: float) -> void:
	if _health <= 0:
		return

	var next_path_position: Vector2 = _nav_agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * _move_speed
	var orientation = get_orientation(new_velocity.normalized()) # NOTE: also flips the sprite!
	
	# NOTE: also controls character state
	animate(orientation)
	
	if not _nav_agent.is_navigation_finished():
		if _nav_agent.avoidance_enabled:
			_nav_agent.set_velocity(new_velocity)
		else:
			_on_nav_agent_velocity_computed(new_velocity)


func _on_animation_finished():
	if _animated_sprite.animation.find("die") != -1:
		_global_state.add_gold(_gold_in_pockets)
		queue_free()


func _nav_agent_setup():
	await get_tree().physics_frame
	_nav_agent.path_desired_distance = 4.0
	_nav_agent.target_desired_distance = 4.0
	_nav_agent.set_target_position(_enemy_destination.global_position)


func get_orientation(direction: Vector2) -> String:
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
	var sprite_frames: SpriteFrames = _animated_sprite.sprite_frames

	if _is_attacking:
		_character_state = "attack"
	else:
		_character_state = "walk"

	var next_animation: String = _character_state + "_" + orientation
	assert(sprite_frames.has_animation(next_animation))
	_animated_sprite.play(next_animation)


func take_damage(amount: int) -> void:
	_health -= amount
	$ProgressBar.value = _health


func _on_aggro_radius_body_entered(body) -> void:
	var distance_between: Vector2 = (body.global_position - global_position).normalized()
	if abs(distance_between.x) + abs(distance_between.y) >= 1:
		_is_attacking = true
		if body.has_method("take_damage"):
			body.take_damage(_attack_power)


func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()


#TODO look up Area2D.is_in_group method and see about putting all projectiles
#into a group...
func _on_hitbox_area_entered(projectile: Area2D) -> void:
	if projectile.target != null and _health > 0:
		var intended_target_id = projectile.target.get_instance_id()
		if get_instance_id() == intended_target_id and projectile.has_method("set_hit_target"):
			var orientation = get_orientation((_enemy_destination.global_position - global_position).normalized()) # NOTE: also flips the sprite!
			take_damage(10)
			projectile.set_hit_target()
			if _health <= 0:
				_health = 0
				_animated_sprite.stop()
				_animated_sprite.play("die_" + orientation)


func _on_health_bar_value_changed(value):
	_health = value
