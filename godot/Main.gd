extends CanvasItem

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


func _on_Play_pressed():
	get_tree().change_scene_to_packed(game_scene)


func _on_Quit_pressed():
	get_tree().quit()
