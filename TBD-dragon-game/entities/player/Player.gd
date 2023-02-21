class_name Player
extends KinematicBody2D

var speed = 400
var jump_impulse = 800
var gravity = 1400

#var dash_unlocked = true
var dash_speed = 1000
var dash_duration = .2
#var can_dash = dash_unlocked

#var max_hp = 5
#var hit_points = 5
#var alive = true

# Persistent variables should be stored here
var info = {
	"max_hp": 5,
	"hit_points": 5,
	"alive": true,
	"dash_unlocked": true,
	"can_dash": true,
	"items": {}, # Will store items carried by player
	"max_inv_size": 25
	# Ex Item List:
	# {0: {"Name": "Peach", "count": 1}, 1: {"Name": "Cherry", "count": 1}}
}

func _ready(): # Prints when it enters the scene tree
	
	print(info) # Check if info is there

var player_direction := Vector2(1, 0)

var velocity := Vector2.ZERO

signal death_triggered

func get_input_direction() -> float:
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	#sprite flipping
	if direction < 0:
		$Sprites.scale.x = -1
		player_direction = Vector2(-1, 0)
	if direction > 0:
		$Sprites.scale.x = 1
		player_direction = Vector2(1, 0)
	
	return direction
	
func get_last_state():
	return $StateMachine.last_state_str

func get_state():
	return info

# HP related
func take_damage(damage:int):
	$AnimationPlayer.play("Hit")
	
	print("Took damage!")
	info["hit_points"] = clamp(info["hit_points"] - damage, 0, info["max_hp"])
	print("Current Hp is ", info["hit_points"])
	if info["hit_points"] <= 0:
		$AnimationPlayer.play("Death")
		
		print("Died!")
		info["alive"] = false
		# emit_signal("death_triggered") TODO keep as below or fix later
		Global.goto_scene(Global.GAME_OVER_SCREEN)
		
func heal(points:int):
	print("Healed!")
	info["hit_points"] = clamp(info["hit_points"] + points, 0, info["max_hp"])

func _on_Area2D_body_entered(body):
	if not body.get("allergy_damage") == null:
		take_damage(body.get("allergy_damage"))
		
# Inventory functions
		
func add_item(item_name):
	if bag_full():
		return false
	else:
		var index = has_item(item_name)
		if index != null && ItemBehaviour.ITEM_DATA[item_name]["Stackable"]:
			info["items"][index]["count"] += 1
		else: # Either not stackable or can't find the item
			print("Not stackable or can't find!")
			info["items"][get_first_empty_slot()] = {"Name": item_name, "count": 1}
		return true
	return false # Shouldn't reach here

func has_item(item_name : String): 
	# item index in dictionary if item exists, otherwise return null
	var items = info["items"]
	for index in items:
		if item_name == items[index]["Name"]:
			return index
	return null

func bag_full():
	return info["items"].keys().size() == info["max_inv_size"]

func get_first_empty_slot():
	# Find the first empty space in the inventory
	# Otherwise return null 
	for i in range(info["max_inv_size"]):
		if !(str(i) in info["items"].keys()):
			return str(i) # str because Json cannot stores numbers as keys
	return null

func move_item(initial_index, target_index):
	# Move item at initial index to target index
	if not initial_index in info["items"]:
		return
	elif not target_index in info["items"]:
		info["items"][target_index] = info["items"][initial_index]
		info["items"].erase(initial_index)
	else:
		var target = info["items"][target_index]
		var initial = info["items"][initial_index]
		info["items"][target_index] = initial
		info["items"][initial_index] = target
