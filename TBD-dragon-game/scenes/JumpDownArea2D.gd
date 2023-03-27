extends Area2D


var can_jump_down = false
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_just_pressed("ui_down") and player != null and can_jump_down:
		print("HERE! Action")
		player.position = Vector2(player.position.x, player.position.y + 1)
		can_jump_down = false

func _on_Area2D_body_entered(body):
	if body.get_name() == 'Player':
		player = body
		can_jump_down = true

func _on_Area2D_body_exited(body):
	if body.get_name() == 'Player':
		player = null
		can_jump_down = false
