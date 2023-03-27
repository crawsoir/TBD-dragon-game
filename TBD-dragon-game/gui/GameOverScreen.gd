extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Try_Again_pressed():
	Global.continue_game()

func _on_Save_and_Exit_pressed():
	Global.refresh_variables()
	Global.goto_scene(Global.TITLE_SCREEN)
