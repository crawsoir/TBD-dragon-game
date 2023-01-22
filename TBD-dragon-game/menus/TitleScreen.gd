extends CanvasLayer

signal start_game
signal continue_game
signal open_options
signal quit
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Wish I could do fade-in transitions here, but that would be a nice-to-have
	#$StartMenuButtons.hide()
	#$Title.hide()
	#yield(get_tree().create_timer(1), "timeout")
	#$StartMenuButtons.show()
	#$Title.show()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Start_pressed():
	emit_signal("start_game")

func _on_Continue_pressed():
	emit_signal("continue_game")

func _on_Options_pressed():
	emit_signal("open_options")

func _on_Quit_pressed():
	emit_signal("quit")

