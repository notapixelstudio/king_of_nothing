extends Control

export var allowance := 0.3
export var metronome_volume := -15

var time_per_tick := 1.0
var time_since_last_tick := 0.0
var is_active := false
var is_already_hit := true

onready var beat_slider_left : Node2D = $left
onready var beat_slider_right : Node2D = $right
onready var beat_slider_center : Node2D = $center
onready var metronome_timer : Timer = $MetronomeTimer
onready var metronome_sound : AudioStreamPlayer = $SoundtrackBeat

export var hit_scene: PackedScene
export var fail_scene: PackedScene

const DELAY_TICK = 0.3

signal tick

func get_is_active() -> bool:
	return is_active

func _ready():
	set_bpm(120)

func set_bpm(value : int):
	if value == 0:
		metronome_sound.volume_db = -100
		metronome_sound.stop()
		is_active = false
		hide()
	else:
		is_active = true
		metronome_sound.volume_db = metronome_volume
		# yield(get_tree().create_timer(DELAY_TICK), "timeout")
		metronome_timer.stop()
		time_per_tick = 60 / float(value)
		metronome_timer.wait_time = time_per_tick
		metronome_sound.play()
		time_since_last_tick = 0.0
		show()
	
	set_physics_process(is_active)
var count_tick = 1
var seconds = 0.0
func _process(delta):
	seconds += delta
	
	var tick_percent = time_since_last_tick / time_per_tick
	
	
	beat_slider_left.position.y = rect_size.y/2
	beat_slider_left.position.x = 0
	beat_slider_right.position.y = rect_size.y/2
	beat_slider_right.position.x = rect_size.x
	beat_slider_center.position = rect_size/2
	time_since_last_tick += delta
	
	if $SoundtrackBeat.get_playback_position()/count_tick  >= time_per_tick:
		emit_signal("tick")
		print(count_tick, " ", time_since_last_tick)
		_on_metronome_timer_timeout()
	
	beat_slider_left.get_node("slider1").position = rect_size * Vector2(tick_percent / 4.0,0)
	beat_slider_left.get_node("slider2").position = rect_size * Vector2(tick_percent / 4.0 + 0.25,0)
	
	beat_slider_right.get_node("slider1").position = rect_size * Vector2(-tick_percent / 4.0,0)
	beat_slider_right.get_node("slider2").position = rect_size * Vector2(-(tick_percent / 4.0 + 0.25),0)

#Called every time a metronome would tick
func _on_metronome_timer_timeout():
	count_tick+=1
	time_since_last_tick = 0.0 #a dirty fix for metronome tick and the beatsliders being not in sync

#Returns whether you hit or not
func is_hitting() -> bool:
	if (time_since_last_tick / time_per_tick > 1 - allowance 
		|| time_since_last_tick/time_per_tick < allowance*0.5) && !is_already_hit:
		is_already_hit = true
		return true
	else:
		return false


func _on_Player_fail():
	var fail = fail_scene.instance()
	add_child(fail)
	fail.global_position = get_node("center").global_position
	fail.scale = rect_scale
	fail.modulate = modulate


func _on_Player_hit():
	var confirm = hit_scene.instance()
	add_child(confirm)
	confirm.global_position = get_node("center").global_position
	confirm.scale = rect_scale
	confirm.modulate = modulate

func stop():
	$left.visible = false
	$right.visible = false
	metronome_timer.stop()
