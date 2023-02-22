extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SPRITE_PATH = "res://entities/item/assets/"
const USABLE_ITEMS = ["HEAL"]
var ITEM_DATA = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	load_item_data()
	
func load_item_data():
	var item_data = File.new()
	if not item_data.file_exists("res://entities/item/ItemData.json"):
		return # Error! We don't have a save to load.
	item_data.open("res://entities/item/ItemData.json", File.READ)
	ITEM_DATA = parse_json(item_data.get_as_text()) # It's just one line
	item_data.close()

func get_image_path(item_name):
	var image_name = ITEM_DATA[item_name]["ImageName"]
	return SPRITE_PATH + image_name

func get_item_texture(item_name):
	return load(get_image_path(item_name))

func usable(item_name):
	if ITEM_DATA[item_name]["Type"] in USABLE_ITEMS:
		return true
	return false
	
# Might need to change this logic in the future
func use(user, item_name):
	if !usable(item_name):
		print("item is not in usable list")
		return false
	var type = ITEM_DATA[item_name]["Type"]
	
	match type:
		"HEAL":
			heal(user, ITEM_DATA[item_name]["Value"])
		_:
			print("functionality not implemented for this item")
	return true

func heal(target, amount):
	target.heal(amount) # Target must have a heal function
	
func trigger(cutscene):
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
