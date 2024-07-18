extends CharacterBody2D

@export var SPEED = 50.0
@export var JUMP_VELOCITY = -200.0

# screen size
var screenSize = DisplayServer.screen_get_size()
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var totalTime = 0
var time = 0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_pressed("space") and is_on_floor():
		if timeout(delta, 5):
			velocity.y = JUMP_VELOCITY * time

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction and is_on_floor():
		velocity.x = direction * SPEED
		if direction > 0:
			$Sprite2D.flip_h = false
		elif direction < 0:
			$Sprite2D.flip_h = true
	else:
		velocity.x = 0
	move_and_slide()
	
var timer = 0

func timeout(delta, maxTime) -> bool:
	timer += delta
	if timer >= maxTime or Input.is_action_just_released("space"):
		time = timer
		timer = 0 
		return true
	else:
		return false
