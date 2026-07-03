extends Node

var oxygen: int = 10
var health: int = 100
var current_level: String
signal oxygen_changed 
signal health_changed

func _ready():
	oxygen_changed.connect(_on_oxygen_changed)
	health_changed.connect(_on_health_changed)

func add_oxygen(pack_size: int):
	if oxygen < 100:
		oxygen = oxygen + pack_size
		oxygen_changed.emit()
	
func remove_oxygen():
	if oxygen > 0:
		oxygen = oxygen - 1
		oxygen_changed.emit()

func add_health(amount: int):
	var new_health = health + amount
	if new_health > 100:
		health = 100
	else:
		health = health + amount
	health_changed.emit()

func remove_health(amount: int):
	if health < 1:
		reset_game()
	else:
		health = health - amount
		health_changed.emit()

func reset_game():
	current_level = "world_one"
	oxygen = 50
	health = 100
	get_tree().reload_current_scene()
	
func collect_item(item_type: String) -> void:
	if item_type == "oxygen":
		add_oxygen(10)
	elif item_type == "health":
		add_health(5)

# automatically called
func _on_oxygen_changed():
	# todo - sound of oxygen added or removed
	pass

func _on_health_changed():
	# todo - sound effects
	pass
