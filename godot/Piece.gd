extends Node2D

class_name Piece

# variables
var speed = 250

export var tile_size = 64
export var type = "king"

var last_pos = Vector2()
var target_pos = Vector2() setget change_pos
var move_dir = Vector2()
export var grid_pos = Vector2() setget change_grid


signal move

func change_grid(new_value):
	grid_pos = new_value # Vector2(new_value.y, new_value.x)
	self.target_pos = Vector2(grid_pos.y, grid_pos.x)*64
	
func change_pos(new_value):
	target_pos = new_value
	print_debug(target_pos/64)

# functions
func _ready():
	add_to_group("moving")
	position = position.snapped(Vector2(tile_size, tile_size))
	last_pos = position
	update_pos()

func update_pos():
	var last_pos = grid_pos
	self.grid_pos += move_dir 
	move_dir = Vector2.ZERO
	emit_signal("move", last_pos, grid_pos)
	
	
func _process(delta):
	get_movedir()
	# movement
	position = target_pos
	
func get_movedir():
	pass