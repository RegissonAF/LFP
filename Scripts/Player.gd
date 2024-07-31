extends CharacterBody2D

class_name Player

@export var SPEED = 50.0


var mutex : Mutex
var thread: Thread
# screen size
var screenSize = DisplayServer.screen_get_size()
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var totalTime = 0

#running variables
var direction : float

# jump variables
@export var MAX_JUMP_VELOCITY = -400.0

const JUMP_FORCE_INCREMENT = 400.0
const MIN_JUMP_SPEED = -200.0

var jumping_direction : float = 0
var current_jump : float = MIN_JUMP_SPEED

func _ready():
	mutex = Mutex.new()
	thread = Thread.new()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	direction = Input.get_axis("move_left", "move_right")
	
	# Handle jump.
	if Input.is_action_pressed("space") and is_on_floor():
		velocity.x = 0
		jump(delta, direction)
		
	elif !Input.is_action_just_released("space") and is_on_floor():
		move(direction)
	
	move_and_slide()


func _input(event):
	if event.is_action_released("space") and is_on_floor():
		velocity += Vector2(jumping_direction, current_jump)
		if velocity.x > 0:
			$Sprite2D.flip_h = false
		elif velocity.x < 0:
			$Sprite2D.flip_h = true
		current_jump = MIN_JUMP_SPEED
		jumping_direction = 0
		print(is_on_floor())


func move(direction):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction and is_on_floor():
		velocity.x = direction * SPEED
		if direction > 0:
			$Sprite2D.flip_h = false
		elif direction < 0:
			$Sprite2D.flip_h = true
	else:
		velocity.x = 0

func jump(delta, direction):
	if direction > 0 or direction < 0:
		jumping_direction = move_toward(jumping_direction, 150*direction, delta*200)
	current_jump = move_toward(current_jump, MAX_JUMP_VELOCITY, delta * JUMP_FORCE_INCREMENT)
	print(jumping_direction)
