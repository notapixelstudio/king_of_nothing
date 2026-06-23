extends Node2D

var speed = Vector2(randf_range(-100,-300),randf_range(-108,-220))
var rps = randf_range(7,13)
var gravity = randf_range(300,400)

func _process(delta):
	position += speed*delta
	rotation += rps*delta
	speed.y += gravity*delta

