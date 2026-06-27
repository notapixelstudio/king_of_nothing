extends Node2D

class_name Piece

signal fail
signal hit

# variables
@export var bpm := 120

@export var tile_size = 64
@export var type = "king": set = set_type
@export var color = "black": set = set_color

func tick():
	anim.play()

var check_moves = []
func set_type(value):
	type = value
	refresh()
	
func set_color(value):
	color = value
	refresh()
	
func refresh():
	$Sprite2D.texture = load('res://assets/pieces/'+color+'_'+type+'.png')

@onready var anim = $Sprite2D/AnimationPlayer
@onready var target = grid_pos
var last_pos = Vector2()
var move_dir = Vector2()
@export var grid_pos = Vector2(): set = change_grid

var captured_pieces = {
	"pawn": 0,
	"bishop": 0,
	"knight": 0,
	"rook": 0,
	"queen": 0
}

signal moved
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
		delta = 60.0/bpm
	elif move_type == "attack":
		delta = 0.5*60.0/bpm
	else:
		delta = 0.25*60.0/bpm
	moved.emit(last_pos, grid_pos)
	if not get_parent():
		return
		
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "position", get_parent().get_parent().ij2xy(grid_pos.x, grid_pos.y), delta)
	
signal captured

func capture(piece: Piece):
	var type_captured = piece.type
	captured.emit(type_captured, captured_pieces[type_captured])
	captured_pieces[type_captured] += 1
	
	# win condition
	if captured_pieces["pawn"]>=8 and captured_pieces["bishop"]>=2 and captured_pieces["knight"]>=2 and captured_pieces["rook"]>=2 and captured_pieces["queen"]>=1:
		emit_signal("winner")
	
func nope():
	print("YOU SHALL NOT PASS")
	
func get_movedir():
	pass

var check_pos = Vector2()

var in_check = false

func check(target_pos : Vector2, moves: Array):
	
	in_check = true
	$Sprite2D/Check.visible = true
	move_dir = target_pos - grid_pos
	target = target_pos
	
	# print("We are ", type , " and we are here: ", grid_pos, " The check is there: ", target_pos, " and we can hit there: ", moves)
	check_moves = moves

func uncheck():
	$Sprite2D/Check.visible = false
	in_check = false
	
