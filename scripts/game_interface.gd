extends CanvasLayer


@onready var global_state := $"/root/Globals" as Globals
@onready var castle_health_label := $CastleHealthLabel as Label
@onready var gold_label := $GoldLabel as Label
var health_label_prefix_text := "Castle Health Remaining: "
var gold_label_prefix_text := "Gold: "


# Called when the node enters the scene tree for the first time.
func _ready():
	castle_health_label.text = health_label_prefix_text + str(global_state.castle_health)
	gold_label.text = gold_label_prefix_text + str(global_state.gold)
	global_state.castle_damaged.connect(_update_castle_health_display)
	global_state.gold_changed.connect(_update_gold_display)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _update_castle_health_display(castle_health: int) -> void:
	castle_health_label.text = health_label_prefix_text + str(castle_health)


func _update_gold_display(gold_amount: int) -> void:
	gold_label.text = gold_label_prefix_text + str(gold_amount)
