extends Node

@onready var interaction_zone: Area2D = $interaction_zone
@onready var doorway: Area2D = $doorway
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_open: bool = false
var animation_done: bool = false

func _ready() -> void:
	interaction_zone.area_entered.connect(_on_interaction_zone_entered)
	doorway.area_entered.connect(_on_doorway_entered)

func _on_interaction_zone_entered(area: Area2D) -> void:
	if is_open:
		return

	if area.name != "collection_area":
		return
		
	if hasKey():
		is_open = true
		sprite.play()
		
		# wait til the door opens
		await sprite.animation_finished
		animation_done = true
		
		# check if player is still in doorway
		for overlapping_area in doorway.get_overlapping_areas():
			if overlapping_area.name == "collection_area":
				complete_level()
	else:
		print("no keys")

func _on_doorway_entered(area: Area2D) -> void:
	if area.name != "collection_area":
		return
		
	# cannot complete level unitl door opens
	if not animation_done:
		return
		
	complete_level()

func complete_level() -> void:
	# safety
	set_deferred("monitoring", false) 
	useKey()
	Globals.complete_level()

func hasKey() -> bool:
	return Globals.keys > 0

func useKey() -> void:
	Globals.keys = Globals.keys - 1
