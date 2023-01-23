extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Wish I could do fade-in transitions here, but that would be a nice-to-have
	#$StartMenuButtons.hide()
	#$Title.hide()
	#yield(get_tree().create_timer(1), "timeout")
	#$StartMenuButtons.show()
	#$Title.show()
	pass

func _on_Start_pressed():
	Global.goto_scene(Global.GAME_SCREEN)

func _on_Continue_pressed():
	#todo
	pass

func _on_Options_pressed():
	Global.goto_scene(Global.OPTIONS_SCREEN)

func _on_Quit_pressed():
	get_tree().quit()

