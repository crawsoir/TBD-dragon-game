extends Node2D

signal character_died

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func cleanup_upon_death():
	# Do anything needed in the scene when the player dies
	pass

func _on_Player_death_triggered():
	cleanup_upon_death()
	emit_signal("character_died")
	Global.goto_scene(Global.GAME_OVER_SCREEN)
