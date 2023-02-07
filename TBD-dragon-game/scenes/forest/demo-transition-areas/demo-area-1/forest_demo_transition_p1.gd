extends Node2D


# Declare member variables here. 
var camera_left_limit = -525
var camera_right_limit = 2000
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_BottomRightDetectionArea2D_body_entered(body):
	if body.get_name() == "Player":
		Global.move_to_area("FOREST_DEMO_TWO", "SpawnMarkers/BottomLeftSpawn")
	

func _on_TopRightDetectionArea2D_body_entered(body):
	if body.get_name() == "Player":
		Global.move_to_area("FOREST_DEMO_TWO", "SpawnMarkers/TopLeftSpawn")
	
