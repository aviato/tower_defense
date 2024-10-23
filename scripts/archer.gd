extends Area2D


@export var arrow_speed: float = 40.0
var _detected_enemies: Array[CharacterBody2D] = []
var _is_shooting: bool = false
var _is_ready: bool = false
@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _cooldown_timer: Timer = $CooldownTimer


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	if _detected_enemies.size() > 0:
		var target := _detected_enemies[0] as CharacterBody2D
		var orientation := _get_orientation((target.global_position - global_position).normalized())

		if _is_ready and not _is_shooting:
			_shoot_arrow(target, orientation)


func _shoot_arrow(target: CharacterBody2D, orientation: String) -> void:
	var game_node := get_node("/root/Main/Game") as Node2D
	var arrow_scene := preload("res://scenes/arrow.tscn") as PackedScene
	var arrow_instance := arrow_scene.instantiate()

	if arrow_instance.set_target:
		arrow_instance.set_target(target, arrow_speed)
		game_node.call_deferred("add_child", arrow_instance)
		arrow_instance.global_position = global_position
		_cooldown_timer.start()
		_animated_sprite.stop()
		_animated_sprite.play("attack_" + orientation)
		_is_ready = false
		_is_shooting = true


func _on_aggro_radius_body_entered(body: CharacterBody2D) -> void:
	_detected_enemies.append(body)
	var orientation := _get_orientation((body.global_position - global_position).normalized())
	_is_ready = true
	_animated_sprite.stop()
	_animated_sprite.play("pre_attack_" + orientation)


func _on_aggro_radius_body_exited(body: CharacterBody2D) -> void:
	var body_index: int = _detected_enemies.find(body)

	if body_index != -1:
		_detected_enemies.pop_at(body_index)
	
	if _detected_enemies.size() == 0:
		_cooldown_timer.stop()
		_animated_sprite.stop()
		_animated_sprite.play("idle_s")
		_is_ready = false
		_is_shooting = false


func _on_cooldown_timer_timeout() -> void:
	_is_ready = true
	_is_shooting = false


func _get_orientation(direction: Vector2) -> String:
	var orientation: String = ""

	if abs(direction.x) > abs(direction.y):
		orientation = "s"
		_animated_sprite.flip_h = direction.x > 0
	else:
		if direction.y < 0:
			orientation = "u"
		else:
			orientation ="d"

	return orientation


func _animate(orientation: String) -> void:
	var sprite_frames := _animated_sprite.sprite_frames as SpriteFrames
	var state := "idle"

	if _is_ready and _is_shooting:
		print("ready and shooting!")
		state = "attack"

	var next_animation: String = state + "_" + orientation
	assert(sprite_frames.has_animation(next_animation))
	_animated_sprite.play(next_animation)
