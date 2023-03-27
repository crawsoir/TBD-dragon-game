extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var camera_left_limit = 0
var camera_right_limit = 13700

var RATBOSS = "res://entities/enemy/RatBoss.tscn"

var boss = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()


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
			
			boss = ResourceLoader.load(RATBOSS).instance()
			boss.connect("rat_boss_defeated", self, "boss_cleanup")
			call_deferred("add_child", boss)
			boss.position = $BossInitiator.position
			boss.player = body
			
			boss.initiate()

func boss_cleanup():
	boss.queue_free()
	$BossGate/BossGate.state = $BossGate/BossGate.OPENING
	Global.quest_progress["gate_quest"]["Status"] = Global.DONE_QUEST
	Global.get_dialogue("Boss2.json")
			
			
