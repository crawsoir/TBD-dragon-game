class_name Player
extends KinematicBody2D

var speed = 400
var jump_impulse = 700
var gravity = 1400
var coyote_duration = .2

var dash_unlocked = true
var dash_speed = 1000
var dash_duration = .2
var can_dash = dash_unlocked

var max_hp = 5
var hit_points = 5
var alive = true
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


# Copied from https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html

func save(): 
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"hit_points" : hit_points,
		"max_hp" : max_hp
	}
	return save_dict

func get_state():
	var save_dict = {
		"hit_points" : hit_points,
	}
	return save_dict

# HP related
func take_damage(damage:int):
	$AnimationPlayer.play("Hit")
	
	print("Took damage!")
	print("Current Hp is ", hit_points)
	hit_points = clamp(hit_points - damage, 0, max_hp)
	if hit_points <= 0:
		$AnimationPlayer.play("Death")
		
		print("Died!")
		alive = false
		# emit_signal("death_triggered") TODO keep as below or fix later
		Global.goto_scene(Global.GAME_OVER_SCREEN)
		
func heal(points:int):
	print("Healed!")
	hit_points = clamp(hit_points + points, 0, max_hp)

func _on_Area2D_body_entered(body):
	if not body.get("allergy_damage") == null:
		take_damage(body.get("allergy_damage"))
