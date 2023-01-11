extends KinematicBody2D

const GRAVITY = 1400
const JUMP_SPEED = -800
const MAX_FALL_SPEED = 2000
const SPEED = 500

var velocity = Vector2.ZERO

func _physics_process(delta):
	get_input()
	
	# gravity
	if velocity.y < MAX_FALL_SPEED:
		velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	play_animation()
		
		
func get_input():
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
	if Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = JUMP_SPEED
			
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
