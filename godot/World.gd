extends Node2D

@export var grid_size: Vector2i = Vector2i(12, 8)
@export var PIECE_DEF_JSON : String
@export var piece_scene : PackedScene
@export var tile_size = 64

@export var gameover_scene : PackedScene
@export var win_scene : PackedScene

@export var max_range_attack = 4

var grid = []
var list_pieces: Array = []
var piece_defs : Dictionary = {}

var bpm := 120
var time_per_tick: float = 60.0/bpm

# keys string in data json
const MOVES = "moves"

var dic_tiles = {
	"move": 3,
	"take": 2,
	"preview":2
}

var count_tick = 0
const SCROLL_TICK = 5
signal gameover
var game_is_over := false

@onready var player = $ChessBoard/Player
func _ready():
	%RhythmControl.set_bpm(bpm)
	
	player.connect("moved", Callable(self, "_on_piece_moved").bind(player))
	
	randomize()
	# list characters
	# Create the grid Array with null in it.
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
	
	# load the piece definition
	piece_defs = global.piece_def
	for k in piece_defs.keys():
		if k != "king":
			list_pieces.append(k)
			
	player.position = ij2xy(player.grid_pos.x, player.grid_pos.y)
	scroll()


#func _input(event):
	#
	## GAME OVER CONDITION
	#
	#var pos = Vector2()
	## this handles the preview when you hover on cells
	#
	#if Input.is_action_pressed("pause"):
		#if get_tree().is_paused():
			#get_tree().set_pause(false)
		#else:
			#get_tree().set_pause(true)



func load_JSON(file_path):
	# example of file path: "res://Ress/panelTextn2.json"
	# ref: https://godotengine.org/qa/8291/how-to-parse-a-json-file-i-wrote-myself
	var dict : Dictionary = {}
	var file = FileAccess.open(file_path, FileAccess.READ)
	var text = file.get_as_text()
	var test_json_conv = JSON.new()
	test_json_conv.parse(text)
	dict = test_json_conv.get_data()
	file.close()
	return dict
	
func get_legal_moves(piece: Piece) -> Dictionary:
	# Will return the legal moves cell in the World (x: column, y: row)
	# gridpos is world coordinate
	var current_grid_pos = piece.grid_pos
	var piece_type = piece.type
	#return the cells where the piece can move
	var piece_moves = []
	var valid_moves = {}
	piece_moves = get_moves(piece_type)
	
	var type_attack = 0
	for move in piece_moves:
		valid_moves[str(type_attack)]= []
		var target_grid_pos = piece.grid_pos + Vector2(move.step[1], move.step[0])
		if not is_within_the_grid(target_grid_pos):
			# if piece.grid_pos.y < 1:
				# print(piece.type , "in ", piece.grid_pos, ": ", move, "-", target_grid_pos)
			# print(piece.type, target_grid_pos , "is not inside the grid. Starting from ", piece.grid_pos)
			continue
		if "repeat" in move:
			var i = 1
			while is_within_the_grid(target_grid_pos) and i <= max_range_attack and is_cell_vacant(target_grid_pos[0], target_grid_pos[1]):
				valid_moves[str(type_attack)].append(target_grid_pos)
				i+=1
				target_grid_pos = piece.grid_pos + Vector2(move.step[1]*i, move.step[0]*i)
			type_attack += 1
			continue
		
		
		if is_cell_vacant(target_grid_pos[0], target_grid_pos[1]):
			valid_moves[str(type_attack)].append(target_grid_pos)
		type_attack += 1

	return valid_moves 

func get_row(i):
	return grid[int(i)%len(grid)]
	
func get_cell(i,j):
	return get_row(i)[int(j)]

func set_cell(i,j, what):
	grid[int(i)%len(grid)][int(j)] = what
	
func is_cell_vacant(i, j) -> bool:
	#check if the cell where the piece wants to move is empty or not
	
	if get_cell(i, j) != null and get_cell(i, j) != player:
		return false
	return true

func get_moves(piece: String):
	#return an array of dictionaries containing the moves of the parameter piece
	return piece_defs[piece]["moves"]

func get_grid_pos(piece):
	#return the position's array of the piece
	return [ceil(piece.position.x / tile_size), ceil(piece.position.y / tile_size)]

func _on_enemy_moved(last_pos, grid_pos, piece):
	if is_within_the_grid(grid_pos):
		var moves = piece.check_moves
		for attack in moves:
			if piece.is_inside_tree() and attack[0] == int(player.grid_pos.x) and attack[1] == int(player.grid_pos.y):
				piece.grid_pos = attack
				print("GAME OVER")
				emit_signal("gameover")
				set_cell(last_pos.x, last_pos.y, null) 
				set_cell(attack[0], attack[1], piece)
				return 
			
			# check if someone is on the way
			if not is_cell_vacant(grid_pos.x, grid_pos.y) and piece != player:
				piece.grid_pos = last_pos
				return
		
		set_cell(last_pos.x,last_pos.y, null) 
		set_cell(grid_pos.x,grid_pos.y, piece)
	else: 
		piece.grid_pos = last_pos
		
		
func _on_piece_moved(last_pos, grid_pos, piece):
	if is_within_the_grid(grid_pos):
		var captured = get_cell(grid_pos.x, grid_pos.y)
		if captured is Piece and piece != captured:
			piece.capture(captured)
			$ChessBoard.remove_child(captured)
			captured.call_deferred("queue_free")
		
		set_cell(last_pos.x,last_pos.y, null) 
		set_cell(grid_pos.x,grid_pos.y, piece)
	else: 
		piece.grid_pos = last_pos
	

func reset_cells(map_to_reset):
	return
	map_to_reset.clear()
	
func is_within_the_grid(pos):
	return pos.y >= 0 and pos.x >= 0 and pos.x< count_scroll*grid_size.x and pos.y < grid_size.y

func show_legal_moves(piece: Piece, legal_moves, map_to_show = $ChessBoard/CursorMap):
	var grid_pos = piece.grid_pos
	var action = "preview"
	for cell in legal_moves:
		# cell[action] could be move, attack
		
		map_to_show.set_cell(cell[1], cell[0]-count_scroll, dic_tiles[action])
		


func _on_tick():
	if game_is_over:
		return
	
	count_tick+=1
	if not count_tick % SCROLL_TICK:
		scroll()
	
	
	player.tick()
	#player.update_pos()
	# yield(get_tree(), "idle_frame")
	for piece in get_tree().get_nodes_in_group("moving"):
		piece.tick()
	await get_tree().create_timer(0.2).timeout
	player.get_movedir()
	for piece in get_tree().get_nodes_in_group("moving"):
		check_piece(piece)


func check_piece(piece: Piece):
	# check if the piece is ready to attack
	if piece.in_check:
		# print(count_tick, " click")
		piece.move(piece.target, "attack", count_tick)
		piece.uncheck()
	else:
		var moves = get_legal_moves(piece)
		for attack_type in moves:
			for attack in moves[attack_type]:
				# check if there is the player in that cell so we can make a "CHECK"
				if attack[0] == int(player.grid_pos.x) and attack[1] == int(player.grid_pos.y):
					piece.check(moves[attack_type][len(moves[attack_type])-1], moves[attack_type])
		
	
var level_script_i = 0
var level_script = [
	'pawn',
	'pawn',
	'pawn',
	'knight',
	'pawn',
	'pawn',
	'knight',
	'pawn',
	'bishop',
	'pawn',
	'pawn',
	'knight',
	'pawn',
	'bishop',
	'pawn',
	'bishop',
	'knight',
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
	

var count_scroll := 0
func scroll():
	# reset_cells($ChessBoard/CursorMap)
	count_scroll +=1
	var new_piece = piece_scene.instantiate()
	new_piece.bpm = bpm
	new_piece.connect("moved", Callable(self, "_on_enemy_moved").bind(new_piece))
	if level_script_i < len(level_script):
		new_piece.type = level_script[level_script_i]
		level_script_i += 1
	else:
		new_piece.type = pieces[randi()%len(pieces)]
		
	var column = randi()%int(grid_size.y)
	# get first line
	var row = count_scroll-1 + len(grid) 
	set_cell(row,column,new_piece)
	new_piece.grid_pos = Vector2(row, column)
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
	
	# new board tiles
	for i in grid_size.x:
		$ChessBoard/TileMap.set_cell(Vector2i(i, -count_scroll), (count_scroll+i)%2, Vector2i(0,0))
	
	var pos = $ChessBoard.position
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property($ChessBoard, "position", pos+Vector2(0, tile_size), time_per_tick*SCROLL_TICK)

func ij2xy(i,j):
	return Vector2(64*j, -64*(i-len(grid)+1))

func kill_last_line():
	if is_instance_valid(%Player) and %Player.grid_pos.x < count_scroll: # WARNING x is row
		emit_signal("gameover")
	
func _on_Player_captured(type, index): # WARNING terrible name, this means "the player captured a piece"
	for score_piece in get_tree().get_nodes_in_group('score_piece'):
		if score_piece.piece_type == type and score_piece.piece_index == index:
			score_piece.taken = true

func _on_World_gameover():
	game_is_over = true
	$ChessBoard.remove_child(player)
	$CanvasLayer/RhythmControl.stop()
	var gameoverr = gameover_scene.instantiate()
	$CanvasLayer.add_child(gameoverr)


func _on_Player_winner():
	game_is_over = true
	$CanvasLayer/RhythmControl.stop()
	var winner = win_scene.instantiate()
	$CanvasLayer.add_child(winner)


func _on_kill_last_line_timer_timeout() -> void:
	if game_is_over:
		return
		
	kill_last_line()
