extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jetpack: GPUParticles2D = $jetpack

@export var thrust_power: float = Globals.thrust_power # how fast player can move
@export var max_speed: float = 300.0 # prevent from going too fast
@export var brake_power: float = 5.0 # how fast to slow down
@export var fuel_depletion_interval: float = 0.2 # how often fuel drops during movement
@export var oxygen_depletion_interval: float = 0.5 # how often oxygen drops constantly
@export var suffocation_interval: float = 1.0 # how fast damage is taken
# rope
@export var rope_length: int = 4
@export var target_distance: float = 30.0 # distance between rope segments
@onready var line: Line2D = $rope
var points_array: Array[Vector2] = []
@export var dragged_object: Node2D

var fuel_timer: float = 0.0
var oxygen_timer: float = 0.0
var suffocation_timer: float = 0.0


func _ready() -> void:
	line.top_level = true 
	for i in range(rope_length):
		points_array.append(global_position)

func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_axis("left", "right")
	input_vector.y = Input.get_axis("up", "down")
	
	# oxygen is constantly depleted
	oxygen_timer += delta
	if oxygen_timer >= oxygen_depletion_interval:
		oxygen_timer = 0.0
		Globals.remove_oxygen()

	# movement if player has fuel
	if input_vector != Vector2.ZERO and Globals.fuel > 0:
			
		# jetpack is on
		jetpack.emitting = true
		input_vector = input_vector.normalized()
		
		# movement
		velocity += input_vector * thrust_power * delta
		velocity = velocity.limit_length(max_speed)
		
		# flip sprite
		animated_sprite.play("run")
		animated_sprite.flip_h = (velocity.x < 0)
		
		# lose fuel only when moving
		fuel_timer += delta
		if fuel_timer >= fuel_depletion_interval:
			fuel_timer = 0.0
			Globals.remove_fuel()
			
	else:
		# jetpack is off
		jetpack.emitting = false
		fuel_timer = 0.0
		
		# movement doesnt stop in space
		if velocity.length() > 5:
			animated_sprite.play("idle")
		else:
			# todo - drift animation
			animated_sprite.play("idle")

	# dammage taken when oxygen is out
	if Globals.oxygen <= 0:
		suffocation_timer += delta
		if suffocation_timer >= suffocation_interval:
			suffocation_timer = 0.0
			Globals.remove_health(1) # damage amount
	else:
		# reset timer if oxygen is found
		suffocation_timer = 0.0

	move_and_slide()
	
	# reset game
	if Input.is_action_just_pressed("menu"):
		Globals.reset_game()

	# ------ rope ------
	if dragged_object and is_instance_valid(dragged_object):
		# maximum length the rope is allowed to expand
		var max_rope_length = rope_length * target_distance
		# check distance between player and cargo
		var distance_to_cargo = global_position.distance_to(dragged_object.global_position)
		
		# pull player back if too far from cargo
		if distance_to_cargo > max_rope_length:
			# find vector pointing from cargo back to player
			var direction_to_player = (global_position - dragged_object.global_position).normalized()
			
			# snap player position to exactly the edge of the tether circle
			global_position = dragged_object.global_position + (direction_to_player * max_rope_length)
			
			# stop forward velocity pulling away from cargo so jetpack doesnt glitch
			var velocity_away = velocity.dot(direction_to_player)
			if velocity_away > 0:
				velocity -= direction_to_player * velocity_away

	points_array[0] = global_position 
	
	# drag rope from player down to cargo while forward movement
	for i in range(1, rope_length):
		var target = points_array[i-1]
		var current = points_array[i]
		if current.distance_to(target) > target_distance:
			points_array[i] = target + (current - target).normalized() * target_distance
		
	# move cargo
	if dragged_object and is_instance_valid(dragged_object):
		var last_point_index = rope_length - 1
		var target_rope_position = points_array[last_point_index]
		var movement_vector = target_rope_position - dragged_object.global_position
		
		var collision = dragged_object.move_and_collide(movement_vector)
		
		# cargo hits a wall
		if collision:
			points_array[last_point_index] = dragged_object.global_position
			# keep rope tight
			for i in range(rope_length - 2, 0, -1):
				var lead = points_array[i+1]
				var curr = points_array[i]
				if curr.distance_to(lead) > target_distance:
					points_array[i] = lead + (curr - lead).normalized() * target_distance
					
		# todo - update drag animations
		#var object_sprite = dragged_object.get_node_or_null("Sprite2D")
		#if object_sprite:
			#if velocity.length() > 10:
				#object_sprite.play("move")
				#if velocity.x != 0:
					#object_sprite.flip_h = (velocity.x < 0)
			#else:
				#object_sprite.play("idle")

	# render
	line.points = points_array
	
	# reset game
	if Input.is_action_just_pressed("menu"):
		Globals.reset_game()
