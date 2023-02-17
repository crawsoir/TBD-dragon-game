class_name Player
extends KinematicBody2D

var speed = 500
var jump_impulse = 800
var gravity = 1400

var velocity := Vector2.ZERO


func get_input_direction() -> float:
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	"""sprite flipping
	if direction < 0:
		$Sprite.flip_h = true
	if direction > 0:
		$Sprite.flip_h = false
	"""
	
	return direction
