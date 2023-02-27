extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player # This should be set elsewhere before adding node to tree
# Called when the node enters the scene tree for the first time.
var max_inv_size
var slot_list = [] # Store node references here
const SLOT = preload("res://gui/inventory/Slot.tscn")
var left_selected_index = null

func _ready():
	# Player value should be set already here
	max_inv_size = player.info["max_inv_size"]
	for index in range(max_inv_size):
		var str_index = str(index)
		var new_slot = SLOT.instance()
		slot_list.append(new_slot)
		# Set up initial slot values as well as signal connections
		new_slot.index = str_index
		new_slot.connect("left_click", self, "_on_left_clicked", [str_index])
		new_slot.connect("right_click", self, "_on_right_clicked", [str_index])
		# Would have to change this behaviour if we go beyond the initial 24 slots but I am in pain rn
		# and a time crunch so please don't torture me further...
		$GridContainer.add_child(new_slot)
	var cur_items = player.info["items"]
	for occupied_index in cur_items:
		var item_data = cur_items[occupied_index] # Should be in the form of {"Name": name, "count": 1}
		var item_name = item_data["Name"]
		slot_list[int(occupied_index)].item = item_data
		slot_list[int(occupied_index)].change_texture(ItemBehaviour.get_item_texture(item_name))
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
# Maybe change this to doing more inside the cells instead
func swap(index1, index2):
	if not index1 in player.info["items"] and not index2 in player.info["items"]:
		#Do nothing
		return
	if not index2 in player.info["items"]:
		move_to_empty_slot(index1, index2)
	elif not index1 in player.info["items"]:
		move_to_empty_slot(index2, index1)
		# Do nothing because this is awkward
	else:
		var old_index1 = player.info["items"][index1]
		var old_index2 = player.info["items"][index2]
		player.info["items"][index1] = old_index2
		player.info["items"][index2] = old_index1
	repaint()
	
func move_to_empty_slot(index1, index2):
	# index 1 is occupied and index2 is empty
	player.info["items"][index2] = player.info["items"][index1] 
	player.info["items"].erase(index1)
	
func throw_item(index:String):
	# TODO: Should do an unthrowable check here
	if index in player.info["items"]:
		player.info["items"].erase(index)
		slot_list[int(index)].change_texture(null)

func use_item(index:String):
	# Get Item type
	var item_data = player.info["items"][index]
	var item_name = item_data["Name"]
	print("Trying to use: " + str(item_data))
	# do something
	if ItemBehaviour.use(player, item_name): #if successfully used
		item_data["count"] -= 1 # reduce count by one
		print("used!")
		if item_data["count"] <= 0: #shouldn't ever be below zero
			throw_item(index)
		
	
func repaint():
	var cur_items = player.info["items"]
	for index in range(max_inv_size):
		var string_index = str(index)
		if string_index in cur_items:
			var item_data = cur_items[string_index] # Should be in the form of {"Name": name, "count": 1}
			var item_name = item_data["Name"]
			slot_list[index].item = item_data
			slot_list[index].change_texture(ItemBehaviour.get_item_texture(item_name))
		else:
			slot_list[index].change_texture(null)

func _on_left_clicked(mouse_global_position, slot_bag_index : String):
	var num_index = int(slot_bag_index)
	if left_selected_index == null:
		if slot_bag_index in player.info["items"]: # I just don't like swapping with empty spaces man 
			left_selected_index = slot_bag_index
			slot_list[int(left_selected_index)].highlight()
			$ThrowButton.show()
			$UseButton.show()
	elif left_selected_index == slot_bag_index:
		slot_list[int(left_selected_index)].unhighlight()
		left_selected_index = null
		$ThrowButton.hide()
		$UseButton.hide()
	else:
		swap(left_selected_index, slot_bag_index)
		slot_list[int(left_selected_index)].unhighlight()
		left_selected_index = null
		$ThrowButton.hide()
		$UseButton.hide()
		
	
func _on_right_clicked(mouse_global_position, slot_bag_index : String):
	var num_index = int(slot_bag_index)
	print("Right clicked signal emitted for inventory for " + slot_bag_index)

func close_inventory():
	self.queue_free()


func _on_ThrowButton_pressed():
	if left_selected_index != null:
		throw_item(left_selected_index)
		slot_list[int(left_selected_index)].unhighlight()
		left_selected_index = null
		$ThrowButton.hide()
		$UseButton.hide()
		


func _on_UseButton_pressed():
	if left_selected_index != null:
		use_item(left_selected_index)
		slot_list[int(left_selected_index)].unhighlight()
		left_selected_index = null
		$ThrowButton.hide()
		$UseButton.hide()
