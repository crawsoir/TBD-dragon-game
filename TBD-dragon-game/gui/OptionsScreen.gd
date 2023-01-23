extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _on_Return_pressed():
	match Global.options_return:
		Global.TITLE_SCREEN:
			Global.goto_scene(Global.TITLE_SCREEN)
		Global.PAUSE_SCREEN:
			Global.goto_scene(Global.PAUSE_SCREEN)
		_:
			print("woops")
