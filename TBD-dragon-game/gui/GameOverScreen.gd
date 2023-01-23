extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Try_Again_pressed():
	#todo
	pass

func _on_Save_and_Exit_pressed():
	#todo: save
	Global.goto_scene(Global.TITLE_SCREEN)
