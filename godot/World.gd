extends Node2D

export var grid_size: Vector2 = Vector2(8, 8)
export var PIECE_DEF_JSON : String
export var piece_scene : PackedScene
export var tile_size = 64
var grid = []
var list_pieces: Array = []
var piece_defs : Dictionary = {}

# keys string in data json
const MOVES = "moves"

var dic_tiles = {
	"move": 3,
	"take": 2,
	"preview":3
	}

func _ready():
	$Player.connect("move", self, "_on_piece_moved", [$Player])
	
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
	
	get_legal_moves($Player)

func _input(event):
	
	# GAME OVER CONDITION
	
	var pos = Vector2()
	# this handles the preview when you hover on cells
	
	if Input.is_action_pressed("pause"):
		if get_tree().is_paused():
			get_tree().set_pause(false)
		else:
			get_tree().set_pause(true)


func _process(delta: float) -> void:
	get_grid_pos($Player)

func load_JSON(file_path):
	# example of file path: "res://Ress/panelTextn2.json"
	# ref: https://godotengine.org/qa/8291/how-to-parse-a-json-file-i-wrote-myself
	var dict : Dictionary = {}
	var file = File.new()
	file.open(file_path, file.READ)
	var text = file.get_as_text()
	dict = parse_json(text)
	file.close()
	return dict
	
func get_legal_moves(piece: Piece):
	var current_grid_pos = piece.position/tile_size
	var piece_type = piece.type
	#return the cells where the piece can move
	var piece_moves = []
	var valid_moves = []
	piece_moves = get_moves(piece_type)

	for move in piece_moves:
		if move.get("repeat"):
			var target_grid_pos = current_grid_pos
			var i = 1
			while target_grid_pos.x < grid_size.x and target_grid_pos.x >= 0 and target_grid_pos.y < grid_size.y and target_grid_pos.y >= 0:
				target_grid_pos += Vector2(move.step[0], move.step[1])
				valid_moves.append(target_grid_pos)
				i+=1
		else:
			print("no repeat")
		if is_cell_vacant(move["step"], current_grid_pos):
			valid_moves.append(move["step"])
	return valid_moves 

func is_cell_vacant(move, current_grid_pos) -> bool:
	#check if the cell where the piece wants to move is empty or not
	var next_grid_pos = []
	next_grid_pos.append(current_grid_pos[0] + move[0])
	next_grid_pos.append(current_grid_pos[1] + move[1])
	if grid[next_grid_pos[0]][next_grid_pos[1]] != null:
		return false
	return true

func get_moves(piece: String):
	#return an array of dictionaries containing the moves of the parameter piece
	return piece_defs[piece]["moves"]

func get_grid_pos(piece):
	#return the position's array of the piece
	return [ceil(piece.position.x / tile_size), ceil(piece.position.y / tile_size)]

func _on_piece_moved(last_pos, grid_pos, piece):

	grid[last_pos.x][last_pos.y] = null
	grid[grid_pos.x][grid_pos.y] = piece
	
	
	
	# print(pos_in_thegrid, " and ", dir, " for ", piece.piece_name)

func reset_cells(map_to_reset):
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			map_to_reset.set_cellv(Vector2(x,y), -1)
			
func is_within_the_grid(pos):
	return pos.x >= 0 and pos.x < grid_size.x and pos.y >= 0 and pos.y < grid_size.y

func show_legal_moves(piece, legal_moves, map_to_show = $ChessBoard/CursorMap):
	var grid_pos = piece.pos_in_the_grid
	var action = "preview"
	for cell in legal_moves:
		# cell[action] could be move, attack
		if map_to_show == $ChessBoard/CursorMap:
			action = cell["action"]
		map_to_show.set_cellv(cell["step"] + grid_pos, dic_tiles[action])

var count_tick = 0
func _on_tick():
	count_tick+=1
	if not count_tick % 5:
		scroll()
		yield(self, "scrolled")
	for piece in get_tree().get_nodes_in_group("moving"):
		piece.update_pos()

signal scrolled
func scroll():
	var new_row = []
	for i in grid_size.y:
		new_row.append(null)
	var new_piece = piece_scene.instance()
	new_piece.type = "bishop"
	
	new_row[randi()%int(grid_size.x)] = new_piece
	grid.pop_back()
	grid.insert(0, new_row)
	for i in len(grid):
		for j in len(grid[i])-1:
			var cell = grid[i][j]
			if cell is Piece:
				cell.grid_pos = Vector2(i, j)
				print("scrolling ? for ", cell.type)
	add_child(new_piece)
	emit_signal("scrolled")
		
	