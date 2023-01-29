extends Node

var TITLE_SCREEN = "res://gui/TitleScreen.tscn"
var GAME_SCREEN = "res://scenes/playground/playground_scene.tscn"
var GAME_OVER_SCREEN = "res://gui/GameOverScreen.tscn"
var OPTIONS_SCREEN = "res://gui/OptionsScreen.tscn"
var PAUSE_SCREEN = "res://gui/PauseScreen.tscn"

#var options_return = TITLE_SCREEN

var current_scene = null

# Keep track of whether the game is paused

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
func goto_scene(path: String):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	# Instancing Pause and Options shouldn't bother
	# change_scene calls because they always queue_free 
	# themselves before switching the current_scene node, which in this case
	# is either the World Node, title screen node, or pause node.
	if path == PAUSE_SCREEN or path == OPTIONS_SCREEN: 
		var new_scene = load(path)
		get_tree().get_root().add_child(new_scene.instance()) 
	else:
		call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.queue_free()

	# which scene options menu should return to
	#if path == TITLE_SCREEN:
	#	options_return = TITLE_SCREEN
	#elif path == PAUSE_SCREEN:
	#	options_return = PAUSE_SCREEN

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)

