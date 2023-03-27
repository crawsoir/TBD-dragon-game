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
var holding = false

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
		slot_list[int(occupied_index)].set_item(item_data)
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
	var item_name = player.info["items"][index]["Name"]
	# Using lazy checking here.
	var cant_throw = item_name in ItemBehaviour.ITEM_DATA and \
		"Throwable" in ItemBehaviour.ITEM_DATA[item_name] and \
		ItemBehaviour.ITEM_DATA[item_name]["Throwable"] == false
	if index in player.info["items"] and not cant_throw:
		player.info["items"].erase(index)
		slot_list[int(index)].change_texture(null)
		slot_list[int(index)].set_item(null)
	else:
		$DetailsWindow.get_node("Description").text = "You can't throw that!"
		$DetailsWindow.show()

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
	slot_list[int(index)].set_text()
	
func repaint():
	var cur_items = player.info["items"]
	for index in range(max_inv_size):
		var string_index = str(index)
		if string_index in cur_items:
			var item_data = cur_items[string_index] # Should be in the form of {"Name": name, "count": 1}
			var item_name = item_data["Name"]
			slot_list[index].set_item(item_data)
			slot_list[index].change_texture(ItemBehaviour.get_item_texture(item_name))
		else:
			slot_list[index].set_item(null)
			slot_list[index].change_texture(null)

func _on_left_clicked(mouse_global_position, slot_bag_index : String):
	var num_index = int(slot_bag_index)
	if left_selected_index == null:
		if slot_bag_index in player.info["items"]: # I just don't like swapping with empty spaces man 
			left_selected_index = slot_bag_index
			slot_list[int(left_selected_index)].highlight()
			$ThrowButton.show()
			$UseButton.show()
			var item_name = player.info["items"][slot_bag_index]["Name"]
			var item_info = ItemBehaviour.ITEM_DATA[item_name]["Description"]
			$DetailsWindow.get_node("Description").text = item_info
			$DetailsWindow.show()
	elif left_selected_index == slot_bag_index:
		slot_list[int(left_selected_index)].unhighlight()
		left_selected_index = null
		$ThrowButton.hide()
		$UseButton.hide()
		$DetailsWindow.hide()
	else:
		swap(left_selected_index, slot_bag_index)
		slot_list[int(left_selected_index)].unhighlight()
		left_selected_index = null
		$ThrowButton.hide()
		$UseButton.hide()
		$DetailsWindow.hide()
		
	
func _on_right_clicked(mouse_global_position, slot_bag_index : String):
	var num_index = int(slot_bag_index)
	print("Right clicked signal emitted for inventory for " + slot_bag_index)

func close_inventory():
	self.player.is_inv_open = false
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

func _on_TextureRect_gui_input(event):
	if event is InputEventMouseMotion && holding:
		self.offset = self.offset + event.relative
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			holding = true
		elif event.button_index == BUTTON_LEFT && !event.pressed:
			holding = false



func _on_CloseButton_pressed():
	close_inventory()
