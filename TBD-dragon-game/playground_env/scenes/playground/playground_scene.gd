extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal character_died

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func cleanup_upon_death():
	# Do anything needed in the scene when the player dies
	pass

func _on_Player_death_triggered():
	cleanup_upon_death()
	emit_signal("character_died")
