extends CanvasLayer

@onready var oxygen_label: Label = $oxygen_amount
@onready var health_label: Label = $health_amount
@onready var fuel_label: Label = $fuel_amount

func _ready() -> void:
	Globals.oxygen_changed.connect(_on_oxygen_changed)
	Globals.health_changed.connect(_on_health_changed)
	Globals.fuel_changed.connect(_on_fuel_changed)
	update_ui()

func _on_oxygen_changed() -> void:
	await get_tree().process_frame 
	update_ui()
	
func _on_health_changed() -> void:
	await get_tree().process_frame 
	update_ui()

func _on_fuel_changed() -> void:
	await get_tree().process_frame 
	update_ui()

func update_ui() -> void:
	if oxygen_label:
		oxygen_label.text = str(Globals.oxygen)
	if health_label:
		health_label.text = str(Globals.health)
	if fuel_label:
		fuel_label.text = str(Globals.fuel)
