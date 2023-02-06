extends KinematicBody2D

const GRAVITY = 1400
const JUMP_SPEED = -800
const MAX_FALL_SPEED = 2000
const SPEED = 500

var velocity = Vector2.ZERO

var max_hp = 5
var hit_points = 5

var alive = true # Needs to stay a bool
var snap_vector = Vector2.DOWN * 16
var jumping = false

signal death_triggered

# Movement
func _physics_process(delta):
	get_input()
	
	if jumping and velocity.y > 0:
		jumping = false
	
	if jumping:
		snap_vector = Vector2()
	else:
		snap_vector = Vector2.DOWN * 16
	
	# gravity
	if velocity.y < MAX_FALL_SPEED:
		velocity.y += GRAVITY * delta
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, true)
	
	play_animation() # Selects animation being played based on the state of the player
		
		
func get_input():
	velocity.x = 0
	
	if not alive: # Prevent velocity changes from user input if player is dead
		return
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
	if Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = JUMP_SPEED
			jumping = true
	if Input.is_action_pressed("ui_cancel"):
		Global.goto_scene(Global.PAUSE_SCREEN)
	if Input.is_action_pressed("ui_accept"):
		pass
			
func play_animation():	
	# flip sprite horizontally
	#if velocity.x < 0:
	#	$Sprite.scale.x = -1 
	#elif velocity.x > 0:
	#	$Sprite.scale.x = 1
	if not is_on_floor():
		$AnimationPlayer.play("jump")
	elif velocity.x != 0:
		$AnimationPlayer.play("run")
	else:
		$AnimationPlayer.play("idle")
		
# HP related
func take_damage(damage:int):
	print("Took damage!")
	print("Current Hp is ", hit_points)
	hit_points = clamp(hit_points - damage, 0, max_hp)
	if hit_points <= 0:
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
