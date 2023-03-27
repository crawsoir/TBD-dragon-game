extends Node2D


var camera_left_limit = -750
var camera_right_limit = 3326

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DetectionArea2D1_body_entered(body):
	if body.get_name() == "Player":
		Global.move_to_area("FOREST", "SpawnMarkers/Spawn1")
