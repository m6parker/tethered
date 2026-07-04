extends Area2D

@export var item_type: String
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
	
	# set sprite
	if item_type and item_type != "":
		var path = "res://assets/items/" + item_type + ".png"
		if ResourceLoader.exists(path):
			sprite.texture = load(path)
		else:
			sprite.texture = load("res://assets/items/oxygen.png")
	else:
		# default to test sprite
		sprite.texture = load("res://assets/items/oxygen.png")
		

func _on_area_entered(area: Area2D) -> void:
	if area.name == "collection_area":
		collect()

func collect() -> void:
	Globals.collect_item(item_type)
	queue_free()
