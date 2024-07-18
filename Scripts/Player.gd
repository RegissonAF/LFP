extends CharacterBody2D

@export var SPEED = 50.0


# screen size
var screenSize = DisplayServer.screen_get_size()
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var totalTime = 0

# jump variables
@export var MAX_JUMP_VELOCITY = -400.0
var current_jump : float = 0.0
var JUMP_FORCE_INCREMENT = -800.0
var MIN_JUMP_SPEED = -200.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_pressed("space") and is_on_floor():
		current_jump = move_toward(current_jump, MAX_JUMP_VELOCITY, delta * JUMP_FORCE_INCREMENT)

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
	

func _input(event):
	if event.is_action_released("space"):
		velocity.y = current_jump
		current_jump = 0
	
