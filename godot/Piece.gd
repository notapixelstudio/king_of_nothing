extends Node2D

class_name Piece

# variables
var speed = 250

export var tile_size = 64
export var type = "king" setget set_type
export var color = "black" setget set_color

func set_type(value):
	type = value
	refresh()
	
func set_color(value):
	color = value
	refresh()
	
func refresh():
	$Sprite.texture = load('res://assets/pieces/'+color+'_'+type+'.png')

var last_pos = Vector2()
var target_pos = Vector2() setget change_pos
var move_dir = Vector2()
export var grid_pos = Vector2() setget change_grid

var captured = {
	"pawn": 0,
	"bishop": 0,
	"knight": 0,
	"rook": 0,
	"queen": 0
	}
signal move

func change_grid(new_value):
	grid_pos = new_value # Vector2(new_value.y, new_value.x)
	
	
func change_pos(new_value):
	target_pos = new_value

# functions
func _ready():
	add_to_group("moving")

func update_pos():
	
	print(type, " " , grid_pos)
	
func move(pos, move_type):
	var last_pos = grid_pos
	grid_pos = pos
	
	var delta
	if move_type == 'scroll':
		delta = 0.5
	else:
		delta = 0.15
		
	move_dir = Vector2.ZERO
	emit_signal("move", last_pos, grid_pos)
	print(grid_pos)
	($Tween as Tween).interpolate_property(self, "position", position, get_parent().get_parent().ij2xy(grid_pos.x, grid_pos.y), delta, Tween.TRANS_LINEAR, Tween.EASE_IN) 
	$Tween.start()
	
signal capture
func capture(piece: Piece):
	var type_captured = piece.type
	emit_signal('capture', type_captured, captured[type_captured])
	captured[type_captured] += 1
	print(captured)
	
func nope():
	print("YOU SHALL NOT PASS")
	
func get_movedir():
	pass