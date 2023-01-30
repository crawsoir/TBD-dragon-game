extends CanvasLayer

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true

func _on_Resume_pressed():
	self.queue_free()
	get_tree().paused = false

func _on_Options_pressed():
	Global.goto_scene(Global.OPTIONS_SCREEN)

func _on_Save_and_Exit_pressed():
	# Undo pausing or else everything will not work
	get_tree().paused = false
	Global.save_game()
	self.queue_free() # cleanup so it doesn't persist as a garbage scene
	Global.goto_scene(Global.TITLE_SCREEN)
