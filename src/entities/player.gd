extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var thrust_power: float = 400.0 # how fast player can move
@export var max_speed: float = 300.0 # prevent from going too fast
@export var brake_power: float = 5.0 # how fast to slow down
@export var oxygen_depletion_interval: float = 0.2 # amount of oxygen lost every 0.2 seconds of movement
@export var suffocation_interval: float = 1.0 # how fast damage is taken

var oxygen_timer: float = 0.0
var suffocation_timer: float = 0.0

func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_axis("left", "right")
	input_vector.y = Input.get_axis("up", "down")
	
	# movement
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		
		# movement
		velocity += input_vector * thrust_power * delta
		velocity = velocity.limit_length(max_speed)
		
		# flip sprite
		animated_sprite.play("run")
		animated_sprite.flip_h = (velocity.x < 0)
		
		# lose oxygen ONLY when moving
		oxygen_timer += delta
		if oxygen_timer >= oxygen_depletion_interval:
			oxygen_timer = 0.0
			Globals.remove_oxygen()
			
	else:
		# movement doesnt stop in space
		if velocity.length() > 5:
			animated_sprite.play("idle")
		else:
			# todo - drift animation
			animated_sprite.play("idle")

	if Globals.oxygen <= 0:
		suffocation_timer += delta
		if suffocation_timer >= suffocation_interval:
			suffocation_timer = 0.0
			Globals.remove_health(5) # dammage amount
	else:
		# reset time if oxygen is found
		suffocation_timer = 0.0

	move_and_slide()
	
	# reset game
	if Input.is_action_just_pressed("menu"):
		Globals.reset_game()
