extends PlayerState


export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)


func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = -player.jump_impulse
		animation_player.play("Jump")


func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	if player.get_input_direction() > 0:
		player.velocity.x = player.speed
	elif player.get_input_direction() < 0:
		player.velocity.x = -player.speed
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if player.is_on_floor():
		if is_zero_approx(player.get_input_direction()):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
