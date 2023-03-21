extends PlayerState


export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)
onready var coyote_timer:Timer = $CoyoteTimer

var coyote_duration = .2
var max_fall_speed = 600

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
	
	# gravity
	if player.velocity.y <= max_fall_speed:
		player.velocity.y += player.gravity * delta
	
	# short and long jumps
	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y -= player.velocity.y / 2
	
	if player.get_input_direction() > 0:
		player.velocity.x = player.speed
	elif player.get_input_direction() < 0:
		player.velocity.x = -player.speed
	else:
		player.velocity.x = 0
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if Input.is_action_pressed("ui_cancel"):
		Global.goto_scene(Global.PAUSE_SCREEN)
	if Input.is_action_just_pressed("dash") and player.info["can_dash"]:
		state_machine.transition_to("Dash")
	if Input.is_action_just_pressed("jump"):
		coyote_timer.wait_time = coyote_duration
		coyote_timer.start()
	if Input.is_action_just_pressed("claw_atk"):
		state_machine.transition_to("Claw_Atk")
		
	if player.is_on_floor():
		if player.info["dash_unlocked"]:
			player.info["can_dash"] = true
		if not coyote_timer.is_stopped():
			state_machine.transition_to("Jump", {do_jump = true})
		elif is_zero_approx(player.get_input_direction()):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
