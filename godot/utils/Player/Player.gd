extends Piece

"""
func _process(delta):
	# movement
	position += speed * move_dir * delta
	
	if position.distance_to(last_pos) >= tile_size - speed * delta:
		position = target_pos
		
	# idle
	if position == target_pos:
		get_movedir()
		
		last_pos = position
		if move_dir != Vector2():
			self.target_pos += move_dir * tile_size
			emit_signal("move", last_pos, move_dir)
"""

var keys = {
	'left': false,
	'right': false,
	'up': false,
	'down': false
}

const tolerance = 0.2

func _ready():
	remove_from_group("moving")
	
func _input(event):
	check_key(event, 'left')
	check_key(event, 'right')
	check_key(event, 'up')
	check_key(event, 'down')
	
func check_key(event, k):
	if event.is_action_pressed('ui_'+k):
		keys[k] = true
		yield(get_tree().create_timer(tolerance*2), 'timeout')
		keys[k] = false
	elif event.is_action_released('ui_'+k):
		yield(get_tree().create_timer(tolerance), 'timeout')
		keys[k] = false
	
# CONTROL KEYS
func get_movedir():
	move_dir.y = -int(keys['left']) + int(keys['right'])
	move_dir.x = -int(keys['down']) + int(keys['up'])
	
	move(grid_pos + move_dir, 'input')
	
	return move_dir