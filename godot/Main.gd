extends CanvasItem

@onready var cursor = $Cursor
@export var game_scene: PackedScene

func start() -> void:
	$anim.play("show")
	$AudioStreamPlayer.play()
	await $anim.animation_finished
	$Options/Play.grab_focus()
	
	
func _ready():
	start()

func _on_Options_focus(focus_node):
	$Focus.play()
	if not cursor.visible:
		cursor.visible = true
	cursor.position.x = $Options.position.x + focus_node.position.x - 30


func _on_Play_pressed():
	get_tree().change_scene_to_packed(game_scene)


func _on_Quit_pressed():
	get_tree().quit()
