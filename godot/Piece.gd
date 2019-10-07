extends Node2D

class_name Piece

# variables
var speed = 250

export var tile_size = 64
export var type = "king" setget set_type

func set_type(value):
	type = value
	$Sprite.texture = load('res://assets/pieces/black_'+type+'.png')

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
	var last_pos = grid_pos
	self.grid_pos += move_dir
	if type == "bishop":
		print(type, " " , grid_pos)
	emit_signal("move", last_pos, grid_pos)
	
func move():
	move_dir = Vector2.ZERO
	($Tween as Tween).interpolate_property(self, "position", position, Vector2(grid_pos.y, grid_pos.x)*64, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN) 
	$Tween.start()
	
signal capture
func capture(piece: Piece):
	var type_captured = piece.type
	emit_signal('capture', type_captured, captured[type_captured])
	captured[type_captured] += 1
	print(captured)
	
func nope():
	print("YOU SHALL NOT PASS")
	
func _process(delta):
	get_movedir()
	# movement
	#position = Vector2(grid_pos.y, grid_pos.x)*64
	
func get_movedir():
	pass