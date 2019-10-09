extends Area2D

# change scene
func _on_GameOver_detector_body_entered(body):
	var bodies = get_overlapping_bodies()     # gets overlapping bodies
	for body in bodies:
		if body.name == "Player":    # find only player name
			get_tree().change_scene("res://gameover.tscn")  # changes scene to game over