extends Node2D

var _enemy_count: int = 100
var _enemies: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	while _enemies <= _enemy_count:
		var orc: PackedScene = preload("res://scenes/orc.tscn")
		var orc_instance: CharacterBody2D = orc.instantiate()
		orc_instance.position.x = randi_range(0, 1000)
		orc_instance.position.y = 700
		add_child(orc_instance)
		_enemies += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

