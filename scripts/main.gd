extends Node2D


@onready var main_menu_scene: CanvasLayer = $MainMenu
var game_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu_scene.connect("start_game", _on_start_game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_start_game():
	print("starting game...")
	game_scene = preload("res://scenes/game.tscn")
	add_child(game_scene.instantiate())
	main_menu_scene.queue_free()
