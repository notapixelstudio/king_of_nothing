extends Node2D

# variables
var speed = 250

export var tile_size = 64
export var piece_name = "king"

var last_pos = Vector2()
var target_pos = Vector2() setget change_pos
var move_dir = Vector2()


signal move

func change_pos(new_value):
	target_pos = new_value
	print_debug(target_pos)

# functions
func _ready():
	position = position.snapped(Vector2(tile_size, tile_size))
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
		if move_dir != Vector2():
			self.target_pos += move_dir * tile_size
			emit_signal("move", last_pos, move_dir)

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
	
	return move_dir