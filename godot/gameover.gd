extends CanvasItem

@onready var cursor = $Cursor

func _ready() -> void:
	hide()
	await get_tree().create_timer(1).timeout
	start()

func start() -> void:
	$anim.play("show")
	$AudioStreamPlayer.play()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property($Tex, "position", $Tex.position + Vector2(0, 20), 1)
	await $anim.animation_finished
	$Options/Play.grab_focus()
	


func _on_btn_play_pressed():
	get_tree().reload_current_scene()


func _on_Options_focus(focus_node):
	$Focus.play()

func _on_Quit_pressed():
	get_tree().quit()
