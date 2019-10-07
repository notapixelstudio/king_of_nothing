extends CanvasLayer


func _ready() -> void:
	#here we have to modify the images according to the player's choice of using white or black
	pass
	
func add_quantity(piece : String) -> void:
	for node in get_node("Control/HBoxContainer").get_children():
		if piece.find(node.name) != -1: #if the piece contains the node name, else do nothing
			node.get_node("QuantityLabel").text = str(str2var(node.get_node("QuantityLabel").text) + 1)