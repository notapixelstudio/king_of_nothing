tool

extends Sprite

export var piece_type : String = 'pawn' setget set_piece_type
export var piece_index : int = 0 setget set_piece_index
export var taken : bool = false setget set_taken

func set_piece_type(value):
	piece_type = value
	refresh()

func set_piece_index(value):
	piece_index = value
	refresh()
	
func set_taken(value):
	taken = value
	refresh()
	
func _ready():
	refresh()
	
func refresh():
	var outline_or_white = 'outline'
	if taken:
		outline_or_white = 'white'
		
	texture = load('res://assets/pieces/'+outline_or_white+'_'+piece_type+'.png')
	