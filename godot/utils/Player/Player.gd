extends KinematicBody2D

# variables
var speed = 250

export var tile_size = 64

var last_pos = Vector2()
var target_pos = Vector2()
var move_dir = Vector2()

# functions
func _ready():
	position = position.snapped(Vector2(tile_size / 2, tile_size / 2))
	last_pos = position
	target_pos = position

func _process(delta):
	# movement
	position += speed * move_dir * delta
	
	if position.distance_to(last_pos) >= tile_size - speed * delta:
		position = target_pos
		
	# idle
	if position == target_pos:
		get_movedir()
		last_pos = position
		target_pos += move_dir * tile_size

# CONTROL KEYS
func get_movedir():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	
	move_dir.x = -int(LEFT) + int(RIGHT)
	move_dir.y = -int(UP) + int(DOWN)
	
	if move_dir.x != 0 && move_dir.y != 0:
		move_dir = Vector2.ZERO