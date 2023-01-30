extends Node

# Variables for managing scenes
var TITLE_SCREEN = "res://gui/TitleScreen.tscn"
var GAME_SCREEN = "res://scenes/playground/playground_scene.tscn"
var GAME_OVER_SCREEN = "res://gui/GameOverScreen.tscn"
var OPTIONS_SCREEN = "res://gui/OptionsScreen.tscn"
var PAUSE_SCREEN = "res://gui/PauseScreen.tscn"

var current_scene = null

# Variables for Saving and Loading
# TODO

# Functions for managing scenes
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
func goto_scene(path: String):
	print(path)
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

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)

func continue_game():
	call_deferred("_continue_game_helper")

func _continue_game_helper():
	_deferred_goto_scene(GAME_SCREEN)
	load_game()
	
# Assumes no persist node is under another persist node
# Call when instantiating a world I guess.
func load_game():
	print("Loading!")
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())
		# 
		var new_object = load(node_data["filename"]).instance()
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
		get_node(node_data["parent"]).add_child(new_object)
	save_game.close()
	print("Loaded!")
	
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_game():
	print("Saving...")
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()
	print("Saved!")
