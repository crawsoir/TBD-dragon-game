extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)


func enter(_msg := {}) -> void:
	animation_player.play("Idle")
	player.info["can_dash"] = player.info["dash_unlocked"]

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Jump")
	
	player.velocity.x = 0
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	if Input.is_action_pressed("ui_cancel"):
		Global.goto_scene(Global.PAUSE_SCREEN)
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {do_jump = true})
	if Input.is_action_just_pressed("dash") and player.info["can_dash"]:
		state_machine.transition_to("Dash")
	if Input.is_action_just_pressed("claw_atk"):
		state_machine.transition_to("Claw_Atk")
	elif not is_zero_approx(player.get_input_direction()):
		state_machine.transition_to("Run")
