extends CanvasLayer

onready var continue_button = $StartMenuButtons/Continue
var save_exists

# Called when the node enters the scene tree for the first time.
func _ready():
	# Wish I could do fade-in transitions here, but that would be a nice-to-have
	#$StartMenuButtons.hide()
	#$Title.hide()
	#yield(get_tree().create_timer(1), "timeout")
	#$StartMenuButtons.show()
	#$Title.show()
	
	# if save does not exist, disable the continue button
	save_exists = Global.check_save_exists()
	if not save_exists:
		continue_button.disabled = true

func _on_Start_pressed():
	if save_exists:
		Global.goto_overlay(Global.CONFIRMATION_BOX)
	else:
		Global.move_to_area("CAVE","DefaultSpawn")

func _on_Continue_pressed():
	Global.continue_game()

func _on_Options_pressed():
	Global.goto_scene(Global.OPTIONS_SCREEN)

func _on_Quit_pressed():
	get_tree().quit()

