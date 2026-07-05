extends Node


var oxygen: int = 10
var fuel: int = 10
var health: int = 100
var thrust_power = 400.0
var current_level: String
signal oxygen_changed 
signal health_changed
signal fuel_changed
signal level_finished
@onready var complete_level_scene: PackedScene = preload("res://src/common/level_complete.tscn")
var complete_level_instance: CanvasLayer = null

func _ready():
	oxygen_changed.connect(_on_oxygen_changed)
	health_changed.connect(_on_health_changed)
	level_finished.connect(complete_level)

func add_oxygen(pack_size: int):
	if oxygen < 100:
		oxygen = oxygen + pack_size
		oxygen_changed.emit()
	
func remove_oxygen():
	if oxygen > 0:
		oxygen = oxygen - 1
		oxygen_changed.emit()
		
func add_fuel(pack_size: int):
	if fuel < 100:
		fuel = fuel + pack_size
		fuel_changed.emit()
	
func remove_fuel():
	if fuel > 0:
		fuel = fuel - 1
		fuel_changed.emit()

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
	fuel = 50
	complete_level_instance.hide()
	complete_level_instance = null
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func collect_item(item_type: String) -> void:
	if item_type == "oxygen":
		add_oxygen(10)
	elif item_type == "fuel":
		add_fuel(10)
	elif item_type == "health":
		add_health(5)

# automatically called
func _on_oxygen_changed():
	# todo - sound of oxygen added or removed
	pass

func _on_health_changed():
	# todo - sound effects
	pass
	
func _on_fuel_changed():
	# todo - sound effects
	pass

func complete_level() -> void:
	print("show menu")
	get_tree().paused = true
	if complete_level_instance == null:
		complete_level_instance = complete_level_scene.instantiate()
		add_child(complete_level_instance)
