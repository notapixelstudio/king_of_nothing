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

# CONTROL KEYS
func get_movedir():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	
	move_dir.y = -int(LEFT) + int(RIGHT)
	move_dir.x = -int(UP) + int(DOWN)
	
	return move_dir