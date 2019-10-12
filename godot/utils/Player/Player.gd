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

var swipe_start = null
var minimum_drag = 100

const tolerance = 0.2

func _ready():
	remove_from_group("moving")
	
func _input(event):
	check_key(event, 'left')
	check_key(event, 'right')
	check_key(event, 'up')
	check_key(event, 'down')

func _unhandled_input(event):
	if event.is_action_pressed("click"):
		swipe_start = get_global_mouse_position()
	if event.is_action_released("click"):
		_calculate_swipe(get_global_mouse_position())

func wait_and_release(direction):
	yield(get_tree().create_timer(tolerance*4), 'timeout')
	keys[direction] = false
		
const THRESHOLD = 50      
func _calculate_swipe(swipe_end):
	if swipe_start == null: 
		return
	var swipe = swipe_end - swipe_start
	print(swipe)
	if abs(swipe.x) > minimum_drag:
		if swipe.x > 0 :
			print("right")
			keys["right"] = true
			wait_and_release("right")
		elif swipe.x < 0 :
			keys["left"] = true
			wait_and_release("left")
	if abs(swipe.y) > minimum_drag:
		if swipe.y < 0 :
			print("up")
			keys["up"] = true
			wait_and_release("up")
		elif swipe.y > 0 :
			keys["down"] = true
			wait_and_release("down")
	print(keys)
			
func check_key(event, k):
	if event.is_action_pressed('ui_'+k):
		keys[k] = true
		yield(get_tree().create_timer(tolerance*4), 'timeout')
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