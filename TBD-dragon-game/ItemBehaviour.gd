extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var sprite_path = "res://entities/item/assets/"

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

func heal(target, amount):
	target.heal(amount) # Target must have a heal function
	
func trigger(cutscene):
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
