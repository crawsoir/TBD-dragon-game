extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ITEM_DATA = {
	"DEFAULT": {"Stackable": true, "Type": "DEFAULT"}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	load_item_data()
	
func load_item_data():
	pass

func heal(player, amount):
	player.heal(amount)
	
func trigger(cutscene):
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
