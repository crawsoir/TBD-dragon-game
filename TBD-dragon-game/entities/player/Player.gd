class_name Player
extends KinematicBody2D

var speed = 400
var jump_impulse = 800
var gravity = 1400

#var dash_unlocked = true
var dash_speed = 1000
var dash_duration = .2
#var can_dash = dash_unlocked

#var max_hp = 5
#var hit_points = 5
#var alive = true

# Persistent variables should be stored here
var info = {
	"max_hp": 5,
	"hit_points": 5,
	"alive": true,
	"dash_unlocked": true,
	"can_dash": true,
	"items": {} # Will store items carried by player
	# Ex Item List:
	# {"PEACH": {"count": 1}, "BERRY": {"count":2}}
}

func _ready(): # Prints when it enters the scene tree
	print(info) # Check if info is there

var player_direction := Vector2(1, 0)

var velocity := Vector2.ZERO

signal death_triggered

func get_input_direction() -> float:
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	#sprite flipping
	if direction < 0:
		$Sprites.scale.x = -1
		player_direction = Vector2(-1, 0)
	if direction > 0:
		$Sprites.scale.x = 1
		player_direction = Vector2(1, 0)
	
	return direction
	
func get_last_state():
	return $StateMachine.last_state_str

func get_state():
	return info

# HP related
func take_damage(damage:int):
	$AnimationPlayer.play("Hit")
	
	print("Took damage!")
	info["hit_points"] = clamp(info["hit_points"] - damage, 0, info["max_hp"])
	print("Current Hp is ", info["hit_points"])
	if info["hit_points"] <= 0:
		$AnimationPlayer.play("Death")
		
		print("Died!")
		info["alive"] = false
		# emit_signal("death_triggered") TODO keep as below or fix later
		Global.goto_scene(Global.GAME_OVER_SCREEN)
		
func heal(points:int):
	print("Healed!")
	info["hit_points"] = clamp(info["hit_points"] + points, 0, info["max_hp"])

func _on_Area2D_body_entered(body):
	if not body.get("allergy_damage") == null:
		take_damage(body.get("allergy_damage"))
