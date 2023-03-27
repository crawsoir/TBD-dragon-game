extends PlayerState

export (NodePath) var _animation_player

onready var animation_player:AnimationPlayer = get_node(_animation_player)
onready var audio_player = $"../../AudioPlayer"

var dmg = 1

func enter(_msg := {}) -> void:
	animation_player.play("Claw_Atk")
	audio_player.play_sound("claw")

func physics_update(delta: float) -> void:
	player.velocity.x = 0
	player.velocity.y += player.gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	if Input.is_action_pressed("ui_cancel"):
		Global.goto_scene(Global.PAUSE_SCREEN)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Claw_Atk":
		state_machine.transition_to("Idle")


func _on_Area2D_Attack_body_entered(body):
	if body.is_in_group("Enemy"):
		body.take_damage(dmg)
		audio_player.play_sound("enemy_hit")
