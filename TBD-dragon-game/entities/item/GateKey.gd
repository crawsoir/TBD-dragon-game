extends "res://entities/item/Item.gd"



# Called when the node enters the scene tree for the first time.
func _ready():
	# initialize variables
	sprite_path = "res://entities/item/assets/key.png"
	item_name = "gate_key"
	# Free self if necessary
	print(Global.quest_progress)
	var relevant_quest = Global.quest_progress["gate_quest"]
	if not Global.spawnable[item_name]:
			self.queue_free()
	._ready()

func on_successful_pickup():
	Global.spawnable[item_name] = false
