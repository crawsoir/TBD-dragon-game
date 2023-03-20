extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var camera_left_limit = 0
var camera_right_limit = 13700

var boss_beaten = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DetectionArea2D1_body_entered(body):
	if body.get_name() == "Player":
		Global.move_to_area("CAVE", "SpawnMarkers/Spawn1")


func _on_BossInitiator_body_entered(body):
	if Global.quest_progress["gate_quest"]["Status"] != Global.DONE_QUEST:
		if $BossGate/BossGate.state == $BossGate/BossGate.OPEN:
			$BossGate/BossGate.state = $BossGate/BossGate.CLOSING
			Global.get_dialogue("Boss1.json")
			
