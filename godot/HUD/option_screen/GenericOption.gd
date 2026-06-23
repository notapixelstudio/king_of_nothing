extends Control

class_name GenericOption

enum OPTION_TYPE{ON_OFF, NUMBER, ARRAY}

signal value_changed

### Properties ###
# Type could be {ON_OFF, NUMBER, ARRAY}
@export var elem_type: OPTION_TYPE = OPTION_TYPE.ON_OFF
# Flag if the value is global
@export var is_global: bool = false
# path of element, defaul separator is "."
@export var element_path: String 
# Text of the label that is going to appear on the Option
@export var label_description: String

@export var node_owner_path: NodePath

var value : set = _set_value
var variable_name: String
var node_owner
var min_value
var max_value
var array_value

func _ready():
	var parent_subpath = element_path.rfind(".")
	var all_path = element_path.split(".")
	
	if parent_subpath > 0:
		var new_description = element_path
		new_description.erase(parent_subpath, len(element_path))
		node_owner = nested_get(node_owner, new_description)
	
	variable_name = all_path[len(all_path)-1]
	
	if is_global:
		node_owner = global
	else:
		node_owner = get_node(node_owner_path)
	set_process_input(false)

func _set_value(new_value):
	value = new_value
	emit_signal("value_changed", value)
	if node_owner:
		node_owner.set(variable_name, value)
	else:
		print("Setter has been called without a proper setup")
		
func _initialize():
	# description_node.text = description
	# value_node.text = str(value)
	# set node and animations if needed
	pass
	
	
func nested_get(ancestor: Node, path:String, separator:String = "."):
	"""
	:param Node ancestor: Ancestor node that has the nested references
	:param str path: String separated by 'separator' that indicates the path
	:param str separator: separator for the 
	:return value from path, NULL if does not exists
	"""
	var nests = path.split(separator)
	var object = ancestor
	var parent
	for property in nests:
		object = object.get(property)
		if object is Node:
			parent = object
	return object