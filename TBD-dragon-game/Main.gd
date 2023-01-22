extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var game_scene = preload("res://playground_env/scenes/playground/playground_scene.tscn")
var game_instance

var death_menu_scene = preload("res://menus/DummyTestMenu.tscn") # TODO: replace
var death_menu_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Title Screen functions
func _on_TitleScreen_quit():
	get_tree().quit()


func _on_TitleScreen_start_game():
	# Delete title screen
	$TitleScreen.queue_free()
	var game_instance = game_scene.instance()
	add_child(game_instance)
	# Add signals required for World here
	# See https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html#connecting-a-signal-via-code
	game_instance.connect("character_died", self, "_on_World_character_died")


func _on_TitleScreen_open_options():
	print("Options button pressed but not yet implemented.")
	# Can add an options instance when pressed.

# TODO: Implement later when saving is made
func _on_TitleScreen_continue_game():
	print("Continue button pressed but not yet implemented.")

# World Related functions and menus

func _on_World_character_died():
	var death_menu_instance = death_menu_scene.instance()
	death_menu_instance.set_text("Died!")
	add_child(death_menu_instance)
