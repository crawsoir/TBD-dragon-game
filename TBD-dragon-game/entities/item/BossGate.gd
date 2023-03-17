extends StaticBody2D

enum {
	OPEN, CLOSED, OPENING, CLOSING
}

var state = CLOSED
var player_in_range = false
var has_key = false
var player = null

func _ready():
	$Prompt.animation = "question"
	$Prompt.visible = false
	$Locked_Prompt/CollisionShape2D.disabled = false
	$AnimationPlayer.current_animation = "closed"
	
func _process(delta):
	match state:
		OPEN:
			player_in_range = false
			$Prompt.visible = false
		CLOSED:
			if Input.is_action_pressed("interact") and player_in_range:
				if has_key:
					Global.get_dialogue("GateUnlocked.json")
					state = OPENING
				else:
					Global.get_dialogue("GateLocked.json")
				player_in_range = false
				$Prompt.visible = false
		OPENING:
			$Locked_Prompt/CollisionShape2D.disabled = true
			$AnimationPlayer.current_animation = "opening"
			state = OPEN
		CLOSING:
			$AnimationPlayer.current_animation = "closing"
			state = CLOSED


func _on_Locked_Prompt_body_entered(body):
	if body.name == 'Player':
		player = body
		$Prompt.visible = true
		player_in_range = true
		if body.has_item("gate_key"):
			$Prompt.animation = "exclaim"
			has_key = true
		else:
			$Prompt.animation = "question"


func _on_Locked_Prompt_body_exited(body):
	$Prompt.visible = false
	player_in_range = false
