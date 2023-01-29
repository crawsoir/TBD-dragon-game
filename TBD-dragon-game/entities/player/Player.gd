extends KinematicBody2D

const GRAVITY = 1400
const JUMP_SPEED = -800
const MAX_FALL_SPEED = 2000
const SPEED = 500

var velocity = Vector2.ZERO

var max_hp = 5
var hit_points = 5

var alive = true # Needs to stay a bool

signal death_triggered

# Movement
func _physics_process(delta):
	get_input()
	
	# gravity
	if velocity.y < MAX_FALL_SPEED:
		velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
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
	if Input.is_action_pressed("ui_cancel"):
		Global.goto_scene(Global.PAUSE_SCREEN)
			
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
		emit_signal("death_triggered")
		
func heal(points:int):
	print("Healed!")
	hit_points = clamp(hit_points + points, 0, max_hp)
		
func _on_Area2D_body_entered(body):
	if not body.get("allergy_damage") == null:
		take_damage(body.get("allergy_damage"))