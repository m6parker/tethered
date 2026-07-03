extends Area2D

func _ready() -> void:
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.name == "collection_area":
		collect()

func collect() -> void:
	Globals.collect_item()
	queue_free()
