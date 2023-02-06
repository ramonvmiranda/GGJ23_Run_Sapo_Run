extends Node

onready var player = get_node("../Player")
onready var respaw = []
onready var audio = get_node("../Audio/BMG loop")
onready var fade = get_node("../CanvasLayer/Fade-in")
onready var anim = get_node("../CanvasLayer/Fade-in/AnimationPlayer")
var timer = Timer.new()


func _ready():
	respaw.append(get_node("../Respaw/resp3"))
	respaw.append(get_node("../Respaw/resp2"))
	respaw.append(get_node("../Respaw/resp1"))
	
	#player.set_pause_mode(Node.PAUSE_MODE_STOP)
	
	get_tree().paused = true
	
	timer.connect("timeout",self,"fade_in")
	timer.wait_time = 8
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
func fade_in():
	anim.play("fade out")		
	
func fade_out():
	anim.play("fade in")	


func pause_n_play(pause):
	get_tree().paused = pause


func _on_Dead_drop_body_entered(body):
	if body.get_name() == "Player":
		_player_die()


func _on_Spikes_body_entered(body):
	if body.get_name() == "Player":
		player.set_visible(false)
		_player_die()
		

func _on_Big_spikes_body_entered(body):
	if body.get_name() == "Player":
		player.set_visible(false)
		_player_die()
	

func _player_die():
	player.set_visible(true)
	for resp in respaw:
		if player.global_position.x <= resp.global_position.x:
			pass
		else:
			player.position = resp.global_position
			break


func _on_BMG_intro_finished():
	audio.play(0.0)


func _on_AnimationPlayer_animation_finished(anim_name):
	var pause = false
	pause_n_play(pause)


func _on_End_level_body_entered(body):
	fade_out()
	var pause = true
	pause_n_play(pause)
	
	get_tree().change_scene("res://Levels/Modernity.tscn")


