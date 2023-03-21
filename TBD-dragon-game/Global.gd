extends Node

# Variables for managing scenes
var CONFIRMATION_BOX = "res://gui/ConfirmationBox.tscn"
var DIALOGUE_BOX = "res://gui/DialogueBox.tscn"
var GAME_OVER_SCREEN = "res://gui/GameOverScreen.tscn"
var GAME_SCREEN = "res://scenes/playground/playground_scene.tscn"
var OPTIONS_SCREEN = "res://gui/OptionsScreen.tscn"
var PAUSE_SCREEN = "res://gui/PauseScreen.tscn"
var TITLE_SCREEN = "res://gui/TitleScreen.tscn"
var PLAYER = "res://entities/player/Player.tscn"

var AREAS = {
	"FOREST_DEMO_ONE": "res://scenes/forest/demo-transition-areas/demo-area-1/forest_demo_transition_p1.tscn",
	"FOREST_DEMO_TWO": "res://scenes/forest/demo-transition-areas/demo-area-2/forest_demo_transition_p2.tscn",
	"FOREST_DEMO_THREE": "res://scenes/forest/demo-transition-areas/demo-area-3/forest_demo_transition_p3.tscn",
	"FOREST": "res://scenes/forest/forest.tscn",
	"CAVE": "res://scenes/cave/starter_cave.tscn"
}

var current_scene = null
var current_area_name = null
# Variables for Saving and Loading
# TODO

# Quest vars
var NEW_QUEST = "NEW"
var IPR_QUEST = "IPR"
var DONE_QUEST = "DONE"
var quest_progress = {
	"test_quest": {
		"Status": NEW_QUEST, # NEW, IPR, DONE,
		"Items": {"QUESTITEM1": 1},
		"Rewards": {"APPLE": 3}
	},
	"gate_quest": {
		"Status": NEW_QUEST, # NEW, IPR, DONE,
		"Items": {"gate_key": 1},
		"Rewards": {"APPLE": 1}
	}
}

var spawnable = {"QUESTITEM1": true, "gate_key": true} # Maybe add respawn timers idk
# It's hacky but we'll track player items here briefly when transitioning
# in order to generate certain items properly

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
	load_game()
	
	
func goto_overlay(path):
	# This function is similar to goto_scene, except the scene does not replace the current scene 
	var s = ResourceLoader.load(path)

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(s.instance())
	
func get_dialogue(dialogue_path):
	var dialogue = ResourceLoader.load(DIALOGUE_BOX)
	var dialogue_instance = dialogue.instance()
	dialogue_instance.get_node("Dialogue Box").dialoguePath = "res://entities/npc/Scripts/" + dialogue_path
	
	get_tree().get_root().add_child(dialogue_instance)
	

func get_player_data(player):
	# Needs to only be called on the Player object
	var return_dict = {
		"Player": player.get_state(),
		"Location": {
			"Area" : current_area_name,
			"x": player.position.x,
			"y": player.position.y
		}
	}
	return return_dict

# For the player moving between different areas.
func move_to_area(area_path: String, target_spawn: String):
	call_deferred("_move_to_area", area_path, target_spawn) # do things safely

func _move_to_area(area_path: String, target_spawn: String):
	# Assumes a player has hit a spot where they need to transition scenes
	# Save necessary data about the player, then spawn the player with that information
	# in the target spawn area of the area the player is moving to.
	
	# This should always make us end up in a different scene UNLESS
	# We spawn the same type of scene for a looping mechanic for some reason.
	
	# SAVE PLAYER INSTANCE CARRYOVER DATA HERE
	var player_data = {} # No data to load
	if current_scene.get_node_or_null("Player") != null:
		# trying to move old player node to new node as a child causes queue free issues
		# For some reason it just keeps spawning the next area and filling up memory
		# So we have to move data this way...
		player_data = get_player_data(current_scene.get_node("Player"))
		player_data = player_data["Player"]
	# Rest of this function is like deferred goto scene
	_load_area_with_player_data(area_path, true, target_spawn, player_data)
	
	
func _load_area_with_player_data(area_path: String, is_spawn_anchor: bool, target_spawn, player_data: Dictionary):
	# Free scene
	current_scene.queue_free()
	# Load the scene of the next_area
	var area_name = area_path
	area_path = Global.AREAS[area_path]
	var next_area = ResourceLoader.load(area_path)
	current_scene = next_area.instance()
	current_area_name = area_name
	# Might want to use constant variables for hardcoded node paths
	# Set player Spawn point
	var player_spawn_position;
	if is_spawn_anchor: # It specifies a node path for a location in the next area
		player_spawn_position = current_scene.get_node(target_spawn).position
	else: # it's in x y format
		player_spawn_position = Vector2(target_spawn["x"], target_spawn["y"])
		
	var player = ResourceLoader.load(PLAYER).instance()
	if not player_data.empty():
		for persistent_data in player_data:
			player.info[persistent_data] = player_data[persistent_data]
	player.position = player_spawn_position
	
	# Set player camera limits based on area limits
	player.get_node("Camera2D").limit_left = current_scene.camera_left_limit
	player.get_node("Camera2D").limit_right = current_scene.camera_right_limit
	
	current_scene.add_child(player)

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	
	
# Assumes no persist node is under another persist node
# Call when instantiating a world I guess.
func load_game():
	print("Loading!")
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# Data we want to load is here
	var player_data;
	var spawn_position;
	var spawn_area;
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	#while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
	#	var node_data = parse_json(save_game.get_line())
		# 
		
	# Code if we save in one line
	var node_data = parse_json(save_game.get_line()) # Currently it's one line so it is how it is
	for key in node_data:
		match key:
			"PlayerInfo":
				var data = node_data["PlayerInfo"]
				player_data = data["Player"]
				var location = data["Location"]
				spawn_position = Vector2(location["x"], location["y"])
				spawn_area = location["Area"]
			"Quests":
				var data = node_data["Quests"]
				quest_progress = data
			"ItemSpawns":
				var data = node_data["ItemSpawns"]
				spawnable = data
			_:
				pass
	save_game.close()
	call_deferred("_load_area_with_player_data", spawn_area, false, spawn_position, player_data)
	
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_game():
	print("Saving...")
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	var node_data = {}
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		var node_name = node.get_name()
		# Different behaviour for different things
		match node_name:
			"Player":
				node_data["PlayerInfo"] = get_player_data(node)
			_:
				pass
	# Save quest info
	node_data["Quests"] = quest_progress
	node_data["ItemSpawns"] = spawnable
		
	# Store the save dictionary as a new line in the save file.
	# Currently it just stores one line I know
	save_game.store_line(to_json(node_data))
	save_game.close()
	print("Saved!")
	
func check_save_exists():
	var save_game = File.new()
	return save_game.file_exists("user://savegame.save")
