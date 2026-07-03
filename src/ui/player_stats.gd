extends CanvasLayer

@onready var oxygen_label: Label = $oxygen_amount 

func _ready() -> void:
	# listen for signal from globals
	Globals.item_pickup.connect(_on_global_item_pickup)
	update_ui()

func _on_global_item_pickup() -> void:
	update_ui()

func update_ui() -> void:
	if oxygen_label:
		oxygen_label.text = str(Globals.oxygen)
