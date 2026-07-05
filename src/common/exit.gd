extends Node

@export var wall_tilemap_layer: TileMapLayer

@onready var interaction_zone: Area2D = $interaction_zone
@onready var doorway: Area2D = $doorway

func _ready() -> void:
	interaction_zone.area_entered.connect(_on_interaction_zone_entered)
	doorway.area_entered.connect(_on_doorway_entered)

func _on_interaction_zone_entered(area: Area2D) -> void:
	if area.name != "collection_area":
		return
		
	if hasKey():
		wall_tilemap_layer.clear()
	else:
		print("no keys")

func _on_doorway_entered(area: Area2D) -> void:
	if area.name != "collection_area":
		return
		
	complete_level()

func complete_level() -> void:
	useKey()
	Globals.complete_level()

func hasKey() -> bool:
	return Globals.keys > 0

func useKey() -> void:
	Globals.keys = Globals.keys - 1
