extends KinematicBody2D

# variables
var MAX_SPEED = 500
var ACCELERATION = 2000
var MOTION = Vector2.ZERO

# functions

func _physics_process(delta):
	var axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
	MOTION = move_and_slide(MOTION)

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis.normalized()

func apply_friction(amount):
	if MOTION.length() > amount:
		MOTION -= MOTION.normalized() * amount
	else:
		MOTION = Vector2.ZERO

func apply_movement(acceleration):
	MOTION += acceleration
	MOTION = MOTION.clamped(MAX_SPEED)