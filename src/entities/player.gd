extends CharacterBody2D

# pulls player up to ceiling when close
@export var ceiling_magnet_force: float = 120.0 
@export var floaty_gravity_scale: float = 0.15
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ceiling_detector: RayCast2D = $ceiling_detector
@onready var collection_area: Area2D = $collection_area
const SPEED = 200.0
const JUMP_VELOCITY = 200.0


func _physics_process(delta: float) -> void:
	up_direction = Vector2.UP

	# flip the player sprite depending on the direction
	var direction := Input.get_axis("left", "right")
	if not is_on_floor() and not is_on_ceiling() and velocity.y <= 50.0:
		if ceiling_detector.is_colliding():
			velocity.y = -ceiling_magnet_force

	# flip the player sprite depending on the surface
	if is_on_floor() or is_on_ceiling():
		if is_on_ceiling():
			animated_sprite.flip_v = true
		else:
			animated_sprite.flip_v = false
			
		if direction:
			velocity.x = direction * SPEED
			animated_sprite.flip_h = (direction < 0)
			animated_sprite.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta * 10)
			animated_sprite.play("idle")
	else:
		# floating
		velocity += get_gravity() * floaty_gravity_scale * delta
		
		animated_sprite.flip_v = false 
		
		if velocity.x != 0:
			animated_sprite.flip_h = (velocity.x < 0)
			
		#todo - jump and fall
		if velocity.y < 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")

	# jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity = Vector2(0, -JUMP_VELOCITY)
		elif is_on_ceiling():
			velocity = Vector2(0, JUMP_VELOCITY + 50.0)
		elif is_on_wall():
			var wall_normal = get_wall_normal()
			velocity = Vector2(wall_normal.x * JUMP_VELOCITY, -JUMP_VELOCITY * 0.5)

	move_and_slide()
	
	if Input.is_action_just_pressed("menu"):
		Globals.reset_game()
