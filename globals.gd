extends Node

var oxygen: int = 50
var health: int
var current_level: String
@onready var oxygen_amount: Label = $oxygen_amount
signal item_pickup

func _ready():
	item_pickup.connect(_on_item_pickup)

func update_oxygen_ui():
	if oxygen_amount:
		oxygen_amount.text = str(oxygen)
	
func add_oxygen():
	if oxygen < 100:
		oxygen = oxygen + 1
		update_oxygen_ui()
	
func remove_oxygen():
	oxygen = oxygen - 1
	update_oxygen_ui()
	if oxygen < 1:
		reset_game()

func add_health(amount: int):
	health = health + amount
	
func remove_health(amount: int):
	health = health - amount

func reset_game():
	current_level = "world_one"
	oxygen = 50
	health = 100
	update_oxygen_ui()
	get_tree().reload_current_scene()
	
func collect_item() -> void:
	item_pickup.emit()

# automattically called
func _on_item_pickup():
	add_oxygen()
