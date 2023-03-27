extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)

var snap_vector = Vector2.DOWN * 16
onready var audio_player = $"../../AudioPlayer"

func enter(_msg := {}) -> void:
	player.info["can_dash"] = player.info["dash_unlocked"]
	animation_player.play("Run")
	audio_player.play_sound("run")


func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		audio_player.stop()
		state_machine.transition_to("Jump")
		return
		
	player.velocity.y += player.gravity * delta
	if player.get_input_direction() > 0:
		player.velocity.x = player.speed
	elif player.get_input_direction() < 0:
		player.velocity.x = -player.speed
	else:
		player.velocity.x = 0
	player.velocity = player.move_and_slide_with_snap(player.velocity, snap_vector, Vector2.UP)
	if Input.is_action_pressed("ui_cancel"):
		Global.goto_scene(Global.PAUSE_SCREEN)
	if Input.is_action_just_pressed("jump"):
		audio_player.stop()
		state_machine.transition_to("Jump", {do_jump = true})
	if Input.is_action_just_pressed("dash") and player.info["can_dash"]:
		audio_player.stop()
		state_machine.transition_to("Dash")
	if Input.is_action_just_pressed("claw_atk"):
		audio_player.stop()
		state_machine.transition_to("Claw_Atk")
	elif is_zero_approx(player.get_input_direction()):
		audio_player.stop()
		state_machine.transition_to("Idle")
	
