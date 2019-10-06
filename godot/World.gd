extends Node2D

export var grid_size: Vector2 = Vector2(8, 8)
var grid = []
var piece_defs = {}
export var PIECE_DEF_JSON : String
var list_pieces: Array = []

# keys string in data json
const MOVES = "moves"

func _ready():
	randomize()
	# list characters
	# Create the grid Array with null in it.
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
	
	# load the piece definition
	piece_defs = load_JSON(PIECE_DEF_JSON)
	for k in piece_defs.keys():
		if k != "king":
			list_pieces.append(k)
			
	print(list_pieces)

func load_JSON(file_path):
	# example of file path: "res://Ress/panelTextn2.json"
	# ref: https://godotengine.org/qa/8291/how-to-parse-a-json-file-i-wrote-myself
	var dict = {}
	var file = File.new()
	file.open(file_path, file.READ)
	var text = file.get_as_text()
	dict = parse_json(text)
	file.close()
	return dict

func get_legal_moves(piece):
	# check which are the legal piece in the board of a given piece
	# return array of legal cells
	return 

func is_cell_vacant(pos_in_the_grid, direction):
	# return the piece that occupies the cell, if hit the boundaries, return null
	var grid_pos = pos_in_the_grid + direction

func get_moves(piece_name):
	# function that get the json for the legal moves. 
	# return array of cells where the piece can move.
	return piece_defs[piece_name][MOVES]