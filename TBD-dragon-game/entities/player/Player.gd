class_name Player
extends KinematicBody2D

onready var audio_player = $AudioPlayerOverride

var speed = 400
var jump_impulse = 800
var gravity = 1200

#var dash_unlocked = true
var dash_speed = 1000
var dash_duration = .3
#var can_dash = dash_unlocked

#var max_hp = 5
#var hit_points = 5
#var alive = true
var is_inv_open = false
signal close_inventory
signal item_obtained
# Persistent variables should be stored here
var info = {
	"max_hp": 5,
	"hit_points": 5,
	"alive": true,
	"dash_unlocked": true,
	"can_dash": true,
	"items": {}, # Will store items carried by player
	"max_inv_size": 24
	# Ex Item List:
	# {0: {"Name": "Peach", "count": 1}, 1: {"Name": "Cherry", "count": 1}}
}

var health_bar = preload("res://gui/health-bar/HealthBar.tscn")
signal hp_changed

func _ready(): # Prints when it enters the scene tree
	health_bar = health_bar.instance()
	health_bar.max_health = info["max_hp"]
	health_bar.current_health = info["hit_points"]
	self.connect("hp_changed", health_bar, "on_health_update")
	self.add_child(health_bar)
	print(info) # Check if info is there
	
	
func _unhandled_input(_event):
	if Input.is_action_just_pressed("bag"):
		if is_inv_open:
			emit_signal("close_inventory")
			is_inv_open = false
		else: # generate inventory with signal attached to it
			var inventory_path = "res://gui/inventory/Inventory.tscn"
			var inventory_scene = ResourceLoader.load(inventory_path)
			var inventory_instance = inventory_scene.instance()
			inventory_instance.player = self
			self.connect("close_inventory", inventory_instance, "close_inventory")
			self.connect("item_obtained", inventory_instance, "repaint")
			#get_tree().get_root().add_child(inventory_instance)
			add_child(inventory_instance)
			is_inv_open = true
			

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
	$StateMachine.transition_to("Hit")
	print("Took damage!")
	info["hit_points"] = clamp(info["hit_points"] - damage, 0, info["max_hp"])
	print("Current Hp is ", info["hit_points"])
	emit_signal("hp_changed", info["max_hp"], info["hit_points"])
	if info["hit_points"] <= 0:
		$StateMachine.transition_to("Death")
		
		print("Died!")
		info["alive"] = false
		# emit_signal("death_triggered") TODO keep as below or fix later
		
		
func heal(points:int):
	print("Healed!")
	info["hit_points"] = clamp(info["hit_points"] + points, 0, info["max_hp"])
	print("Hit points now at " + str(info["hit_points"]))
	emit_signal("hp_changed", info["max_hp"], info["hit_points"])

func _on_Area2D_body_entered(body):
	if not body.get("allergy_damage") == null:
		take_damage(body.get("allergy_damage"))
		
# Inventory functions
		
func add_item(item_name):
	print(info["items"])
	if bag_full():
		return false
	else:
		var index = has_item(item_name)
		if index != null && ItemBehaviour.ITEM_DATA[item_name]["Stackable"]:
			info["items"][index]["count"] += 1
		else: # Either not stackable or can't find the item
			print("Not stackable or can't find!")
			info["items"][get_first_empty_slot()] = {"Name": item_name, "count": 1}
		emit_signal("item_obtained")
		return true
	return false # Shouldn't reach here

# Not the most optimized way to add items nor does it check if we exceeded
# inventory space
func add_items(item_name, count):
	while count > 0:
		add_item(item_name)
		count = count - 1
	

func get_number_of_item(item_name : String):
	var items = info["items"]
	var acc = 0
	for index in items:
		if item_name == items[index]["Name"]:
			acc = acc + items[index]["count"]
	return acc

func remove_items(item_name : String, item_count):
	# Remove up to item_count items from the inventory
	var items = info["items"]
	for index in items:
		if item_name == items[index]["Name"]:
			var original_count = items[index]["count"]
			if item_count >= original_count:
				item_count = item_count - original_count
				items.erase(index)
			else: # original_count < item_count
				items[index]["count"] = items[index]["count"] - item_count
				return

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
		
func get_items_list():
	return info["items"] # A reference to the list of items
			
