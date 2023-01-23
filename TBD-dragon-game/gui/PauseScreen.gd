extends CanvasLayer

#TODO: implement pausing
func _on_Resume_pressed():
	Global.goto_scene(Global.GAME_SCREEN)

func _on_Options_pressed():
	Global.goto_scene(Global.OPTIONS_SCREEN)

func _on_Save_and_Exit_pressed():
	#todo: save
	Global.goto_scene(Global.TITLE_SCREEN)
