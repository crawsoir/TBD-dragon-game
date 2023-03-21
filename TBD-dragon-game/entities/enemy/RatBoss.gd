extends KinematicBody2D

var max_health = 10
var current_health = 10
signal rat_boss_defeated
var positions = {
	"TOP": {"x": 669, "y":1550},
	"LEFT": {"x": 350, "y":1682},
	"RIGHT": {"x": 993, "y":1682},
	"MID": {"x": 674, "y":1830}
}
var target_position = positions["MID"]

var player

enum {
	PHASE_ONE,
	PHASE_TWO,
	DEFEATED
}
var state_machine
var stage = PHASE_ONE
onready var idle_timer:Timer = $IdleTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	idle_timer.wait_time = 7
	idle_timer.one_shot = true
	idle_timer.start()

func _process(delta):
	if current_health <= (max_health/2):
		if stage == PHASE_ONE:
			stage = PHASE_TWO
			state_machine.travel("Transform")
			idle_timer.wait_time = 5
			idle_timer.start()
	if current_health <= 0:
		stage = DEFEATED
		state_machine.travel("Defeated")
	
	match stage:
		PHASE_ONE:
			var velocity = Vector2(target_position["x"] - position.x, target_position["y"] - position.y).normalized()
			if position.distance_to(Vector2(target_position["x"], target_position["y"])) > 3:
				position += velocity*2
			
			if idle_timer.is_stopped() and (state_machine.get_current_node() == "Idle"):
				var rand_number = randi()%2+1
				if rand_number == 1:
					state_machine.travel("RotateAttack")
					idle_timer.wait_time = 16
				else:
					state_machine.travel("DownAttack")
					idle_timer.wait_time = 8
					
				idle_timer.start()
				target_position = get_random_position()
				
		PHASE_TWO:
			var velocity = Vector2(target_position["x"] - position.x, target_position["y"] - position.y).normalized()
			if position.distance_to(Vector2(target_position["x"], target_position["y"])) > 3:
				position += velocity*3
			
			if idle_timer.is_stopped() and (state_machine.get_current_node() == "PhaseTwoIdle"):
				var rand_number = randi()%2+1
				if rand_number == 1:
					state_machine.travel("PhaseTwoRotateAttack")
					idle_timer.wait_time = 15
				else:
					state_machine.travel("PhaseTwoDownAttack")
					idle_timer.wait_time = 7
					
				idle_timer.start()
				target_position = get_random_position()
		DEFEATED:
			if state_machine.get_current_node() == "Defeated_Anim_Finished":
				emit_signal("rat_boss_defeated")
				player.add_items("Apple", 1)
				player.remove_items("gate_key", 1)

# set the player variable before calling this
func initiate():
	state_machine = $AnimationTree.get("parameters/playback")
	state_machine.start("Spawning")

func take_damage(dmg):
	current_health -= dmg
	
func get_random_position():
   var pos = positions.keys()
   pos = pos[randi() % pos.size()]
   return positions[pos]

func _on_BodyCollision_body_entered(body):
	if body.name == "Player":
		#body.take_damage(1)
		pass

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		#body.take_damage(1)
		pass
			
