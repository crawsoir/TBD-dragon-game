extends TextureRect


const EMPTY = preload("res://gui/health-bar/assets/EmptyHeart.png")
const FULL = preload("res://gui/health-bar/assets/FullHeart.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

func set_full():
	self.texture = FULL
	
func set_empty():
	self.texture = EMPTY
