extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)
onready var dash_timer:Timer = $DashTimer

func enter(_msg := {}) -> void:
	animation_player.play("Dash")
	player.velocity.y = 0
	player.velocity.x = player.player_direction.x * player.dash_speed
	
	# setting up and starting the dash timer
	dash_timer.wait_time = player.dash_duration
	dash_timer.one_shot = true
	dash_timer.start()
	

func physics_update(delta: float) -> void:
	if dash_timer.is_stopped():
		player.velocity.x = 0
		player.can_dash = false
		state_machine.transition_to(player.get_last_state())
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	if Input.is_action_pressed("ui_cancel"):
		Global.goto_scene(Global.PAUSE_SCREEN)
	
