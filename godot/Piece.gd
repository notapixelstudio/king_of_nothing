extends Node2D

class_name Piece

signal fail
signal hit

# variables
var speed = 250

export var tile_size = 64
export var type = "king" setget set_type
export var color = "black" setget set_color


var check_moves = []
func set_type(value):
	type = value
	refresh()
	
func set_color(value):
	color = value
	refresh()
	
func refresh():
	$Sprite.texture = load('res://assets/pieces/'+color+'_'+type+'.png')

onready var target = grid_pos
var last_pos = Vector2()
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
signal winner

func change_grid(new_value):
	grid_pos = new_value # Vector2(new_value.y, new_value.x)
	
	

# functions
func _ready():
	add_to_group("moving")

	
func move(pos, move_type,  tick = 0):
	
	if move_dir == Vector2.ZERO:
		emit_signal("fail")
		return
	emit_signal("hit")
	var last_pos = grid_pos
	grid_pos = pos
	
	var delta
	if move_type == 'scroll':
		delta = 0.5
	elif move_type == "attack":
		delta = 0.25
	else:
		delta = 0.15
	emit_signal("move", last_pos, grid_pos)
	if not get_parent():
		return
	($Tween as Tween).interpolate_property(self, "position", position, get_parent().get_parent().ij2xy(grid_pos.x, grid_pos.y), delta, Tween.TRANS_LINEAR, Tween.EASE_IN) 
	$Tween.start()
	
signal capture

func capture(piece: Piece):
	var type_captured = piece.type
	emit_signal('capture', type_captured, captured[type_captured])
	captured[type_captured] += 1
	
	# win condition
	if captured["pawn"]>=8 and captured["bishop"]>=2 and captured["knight"]>=2 and captured["rook"]>=2 and captured["queen"]>=1:
		emit_signal("winner")
	
func nope():
	print("YOU SHALL NOT PASS")
	
func get_movedir():
	pass

var check_pos = Vector2()

var in_check = false

func check(target_pos : Vector2, moves: Array):
	
	in_check = true
	$Sprite/Check.visible = true
	move_dir = target_pos - grid_pos
	target = target_pos
	
	# print("We are ", type , " and we are here: ", grid_pos, " The check is there: ", target_pos, " and we can hit there: ", moves)
	check_moves = moves

func uncheck():
	$Sprite/Check.visible = false
	in_check = false
	