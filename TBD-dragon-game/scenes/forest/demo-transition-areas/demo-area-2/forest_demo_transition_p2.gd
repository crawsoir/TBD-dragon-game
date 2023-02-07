extends Node2D


# Declare member variables here.
var camera_left_limit = -0
var camera_right_limit = 2300
# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _on_TopLeftDetectionArea2D_body_entered(body):
	if body.get_name() == "Player":
		Global.move_to_area("FOREST_DEMO_ONE", "SpawnMarkers/TopRightSpawn")
		

func _on_BottomLeftDetectionArea2D_body_entered(body):
	if body.get_name() == "Player":
		Global.move_to_area("FOREST_DEMO_ONE", "SpawnMarkers/BottomRightSpawn")


func _on_TopRightDetectionArea2D_body_entered(body):
	if body.get_name() == "Player":
		Global.move_to_area("FOREST_DEMO_THREE", "SpawnMarkers/TopLeftSpawn")


func _on_BottomRightDetectionArea2D_body_entered(body):
	if body.get_name() == "Player":
		Global.move_to_area("FOREST_DEMO_THREE", "SpawnMarkers/BottomLeftSpawn")
