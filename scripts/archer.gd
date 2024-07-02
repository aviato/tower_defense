extends Area2D


@onready var cooldown_timer: Timer = $CooldownTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var arrow_speed: float = 400.0
var _is_shooting: bool = false
var _detected_enemies: Array = []
var _is_ready: bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _detected_enemies.size() > 0 and _is_ready:
		ready_arrow()


func ready_arrow() -> void:
	var arrow_scene: PackedScene = preload("res://scenes/arrow.tscn")
	var arrow_instance: Node2D   = arrow_scene.instantiate()
	var game_node: Node2D        = get_node("/root/Main/Game")
	var target: CharacterBody2D  = _detected_enemies[0] as CharacterBody2D
	arrow_instance.set_target(target)
	game_node.call_deferred("add_child", arrow_instance)
	arrow_instance.global_position = global_position
	cooldown_timer.start()
	_is_ready = false
	

func _on_aggro_radius_body_entered(body):
	_detected_enemies.append(body)


func _on_aggro_radius_body_exited(body):
	cooldown_timer.stop()
	var body_index: int = _detected_enemies.find(body)
	if body_index != -1:
		_detected_enemies.pop_at(body_index)


func _on_cooldown_timer_timeout():
	_is_ready = true
	
