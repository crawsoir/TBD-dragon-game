extends PlayerState


export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)
onready var coyote_timer:Timer = $CoyoteTimer

func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = -player.jump_impulse
		
	#coyote time
	coyote_timer.one_shot = true

func physics_update(delta: float) -> void:
	if player.velocity.y > 0:
		animation_player.play("Fall")
	else:
		animation_player.play("Jump")
	
	player.velocity.y += player.gravity * delta
	if player.get_input_direction() > 0:
		player.velocity.x = player.speed
	elif player.get_input_direction() < 0:
		player.velocity.x = -player.speed
	else:
		player.velocity.x = 0
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if Input.is_action_pressed("ui_cancel"):
		Global.goto_scene(Global.PAUSE_SCREEN)
	if Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")
	if Input.is_action_just_pressed("jump"):
		coyote_timer.wait_time = player.coyote_duration
		coyote_timer.start()
	if Input.is_action_just_pressed("claw_atk"):
		state_machine.transition_to("Claw_Atk")
		
	if player.is_on_floor():
		if player.dash_unlocked:
			player.can_dash = true
		if not coyote_timer.is_stopped():
			state_machine.transition_to("Jump", {do_jump = true})
		elif is_zero_approx(player.get_input_direction()):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
