extends Node2D

export var grid_size: Vector2 = Vector2(12, 8)
export var PIECE_DEF_JSON : String
export var piece_scene : PackedScene
export var tile_size = 64
var grid = []
var list_pieces: Array = []
var piece_defs : Dictionary = {}


onready var timer = $Timer
# keys string in data json
const MOVES = "moves"

var dic_tiles = {
	"move": 3,
	"take": 2,
	"preview":2
	}

onready var player = $ChessBoard/Player
func _ready():
	player.connect("move", self, "_on_piece_moved", [player])
	print(player.position)
	
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
	player.position = ij2xy(player.grid_pos.x, player.grid_pos.y)
	
	get_legal_moves(player)
	scroll()
	print(grid)


func _input(event):
	
	# GAME OVER CONDITION
	
	var pos = Vector2()
	# this handles the preview when you hover on cells
	
	if Input.is_action_pressed("pause"):
		if get_tree().is_paused():
			get_tree().set_pause(false)
		else:
			get_tree().set_pause(true)



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
	var current_grid_pos = piece.grid_pos
	var piece_type = piece.type
	#return the cells where the piece can move
	var piece_moves = []
	var valid_moves = []
	piece_moves = get_moves(piece_type)

	for move in piece_moves:
		
		if "repeat" in move:
			var target_grid_pos = piece.grid_pos
			var i = 1
			while is_within_the_grid(target_grid_pos):
				target_grid_pos = piece.grid_pos + Vector2(move.step[0]*i, move.step[1]*i)
				valid_moves.append(target_grid_pos)
				i+=1
		else:
			# print("no repeat")
			pass
		if is_cell_vacant(move["step"], current_grid_pos):
			valid_moves.append(Vector2(move["step"][0]+current_grid_pos.x, move["step"][1]+current_grid_pos.y))
	return valid_moves 

func get_row(i):
	return grid[int(i)%len(grid)]
	
func get_cell(i,j):
	return get_row(i)[int(j)]

func set_cell(i,j, what):
	grid[int(i)%len(grid)][int(j)] = what
	
func is_cell_vacant(move, current_grid_pos) -> bool:
	#check if the cell where the piece wants to move is empty or not
	var next_grid_pos = []
	next_grid_pos.append(current_grid_pos[0] + move[0])
	next_grid_pos.append(current_grid_pos[1] + move[1])
	if get_cell(next_grid_pos[0],next_grid_pos[1]) != null:
		return false
	return true

func get_moves(piece: String):
	#return an array of dictionaries containing the moves of the parameter piece
	return piece_defs[piece]["moves"]

func get_grid_pos(piece):
	#return the position's array of the piece
	return [ceil(piece.position.x / tile_size), ceil(piece.position.y / tile_size)]

func _on_piece_moved(last_pos, grid_pos, piece):
	if is_within_the_grid(grid_pos):
		if get_cell(grid_pos.x,grid_pos.y) is Piece and get_cell(grid_pos.x,grid_pos.y) != piece:
			var captured = get_cell(grid_pos.x,grid_pos.y)
			print("CAPUTRED", captured.type)
			piece.capture(captured)
			captured.queue_free()
		
		# TODO
		set_cell(last_pos.x,last_pos.y, null) 
		set_cell(grid_pos.x,grid_pos.y, piece)
	else: 
		piece.grid_pos = last_pos
	
	
	
	# print(pos_in_thegrid, " and ", dir, " for ", piece.piece_name)

func reset_cells(map_to_reset):
	return
	map_to_reset.clear()
	
func is_within_the_grid(pos):
	return true
	return pos.x >= 0 and pos.x < grid_size.x and pos.y >= 0 and pos.y < grid_size.y

func show_legal_moves(piece: Piece, legal_moves, map_to_show = $ChessBoard/CursorMap):
	var grid_pos = piece.grid_pos
	var action = "preview"
	print(piece.type, " ", legal_moves)
	for cell in legal_moves:
		# cell[action] could be move, attack
		
		map_to_show.set_cell(cell[1], cell[0]-count_scroll, dic_tiles[action])
		

var count_tick = 0
const SCROLL_TICK = 5

func _on_tick():
	count_tick+=1
	if not count_tick % SCROLL_TICK:
		scroll()
		yield(self, "scrolled")
	
	player.get_movedir()
	#player.update_pos()
	yield(get_tree(), "idle_frame")
	for piece in get_tree().get_nodes_in_group("moving"):
		piece.update_pos()
		
	kill_last_line()

signal scrolled

var script_i = 0
var script = [
	'pawn',
	'pawn',
	'pawn',
	'pawn',
	'pawn',
	'knight',
	'pawn',
	'pawn',
	'knight',
	'pawn',
	'pawn',
	'pawn',
	'bishop',
	'pawn',
	'pawn',
	'pawn',
	'knight',
	'pawn',
	'bishop',
	'pawn',
	'bishop',
	'knight',
	'pawn',
	'pawn',
	'rook',
	'pawn',
	'knight',
	'rook',
	'pawn',
	'bishop',
	'rook',
	'pawn',
	'rook',
	'pawn',
	'queen',
	'pawn'
]

var pieces = [
	'pawn',
	'knight',
	'bishop',
	'rook',
	'queen'
]

var count_scroll = 0
func scroll():
	# reset_cells($ChessBoard/CursorMap)
	count_scroll +=1
	var new_piece = piece_scene.instance()
	new_piece.connect("move", self, "_on_piece_moved", [new_piece])
	if script_i < len(script):
		new_piece.type = script[script_i]
		script_i += 1
	else:
		new_piece.type = pieces[randi()%len(pieces)]
		
	var column = randi()%int(grid_size.y)
	# get first line
	var row = count_scroll-1 + len(grid) 
	set_cell(row,column,new_piece)
	new_piece.grid_pos = Vector2(column, row)
	new_piece.position = ij2xy(row, column)
	$ChessBoard.add_child(new_piece)
	"""
	for i in len(grid):
		for j in len(grid[i])-1:
			var cell = grid[i][j]
			if cell is Piece:
				cell.move(Vector2(i, j), 'scroll')
				show_legal_moves(new_piece, get_legal_moves(new_piece))
	"""
	emit_signal("scrolled")
	
	var pos = $ChessBoard.position
	$ChessBoard/Tween.interpolate_property($ChessBoard, "position", pos, pos+Vector2(0, tile_size), timer.wait_time*SCROLL_TICK, Tween.TRANS_LINEAR, Tween.EASE_IN) 
	$ChessBoard/Tween.start()
	
	for i in grid_size.x:
		$ChessBoard/TileMap.set_cell(i, -count_scroll, (count_scroll+i)%2)
	
	kill_last_line()

func ij2xy(i,j):
	return Vector2(64*j, -64*(i-len(grid)+1))

func kill_last_line():
	# get last line
	return
	"""
	for cell in get_row(count_scroll-1):
		if cell is Piece:
			if cell.type != 'king':
				cell.queue_free()
			else:
				print('gameover')
	"""
func _on_Player_capture(type, index):
	for score_piece in get_tree().get_nodes_in_group('score_piece'):
		if score_piece.piece_type == type and score_piece.piece_index == index:
			score_piece.taken = true
			