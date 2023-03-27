extends Node2D

var audio_claw_attack = preload("res://entities/player/assets/claw-attack.mp3")
var audio_dash = preload("res://entities/player/assets/dash.mp3")
var audio_land = preload("res://entities/player/assets/land.mp3")
var audio_run = preload("res://entities/player/assets/player-run.mp3")
var audio_player_hit = preload("res://entities/player/assets/player_hit.mp3")
var audio_enemy_hit = preload("res://entities/player/assets/enemy_hit.mp3")

var audio_node = null

func _ready():
	audio_node = $AudioStreamPlayer
	audio_node.connect("finished", self, "stop")
	audio_node.stop()	

# not very clean but works for now
func play_sound(sound_name):
	match sound_name:
		"claw":
			audio_node.stream = audio_claw_attack
		"dash":
			audio_node.stream = audio_dash
		"land":
			audio_node.stream = audio_land
		"run":
			audio_node.stream = audio_run
		"player_hit":
			audio_node.stream = audio_player_hit
		"enemy_hit":
			audio_node.stream = audio_enemy_hit
		_:
			print ("UNKNOWN STREAM")
			queue_free()

	audio_node.play()
	
func stop():
	audio_node.stop()
