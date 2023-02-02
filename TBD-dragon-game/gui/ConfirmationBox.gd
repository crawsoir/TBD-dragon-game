extends CanvasLayer

func _on_Yes_pressed():
	Global.goto_scene(Global.GAME_SCREEN)
	queue_free()

func _on_No_pressed():
	queue_free()
