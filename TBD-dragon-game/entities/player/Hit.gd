extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimationPlayer = get_node(_animation_player)
onready var hit_effect_timer:Timer = $HitEffectTimer

func enter(_msg := {}) -> void:
	animation_player.play("Hit")
	hit_effect_timer.start()
	$"../../AudioPlayer".play_sound("player_hit")
	$"../..".modulate = Color(255, 255, 255)

func physics_update(delta: float) -> void:
	player.velocity = player.move_and_slide(player.player_direction*-40, Vector2.UP)
	if hit_effect_timer.is_stopped():
		$"../..".modulate = Color(1, 1, 1)
		state_machine.transition_to("Idle")
