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

var captured = {
	"shogi_pawn": 0,
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
	position = position.snapped(Vector2(tile_size, tile_size))
	last_pos = position
	move()

func update_pos():
	var last_pos = grid_pos
	self.grid_pos += move_dir
	if type == "bishop":
		print(grid_pos)
	emit_signal("move", last_pos, grid_pos)
	
func move():
	move_dir = Vector2.ZERO
	($Tween as Tween).interpolate_property(self, "position", position, Vector2(grid_pos.y, grid_pos.x)*64, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN) 
	$Tween.start()
	
func capture(piece: Piece):
	var type_captured = piece.type
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