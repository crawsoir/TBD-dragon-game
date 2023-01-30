extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS # Otherwise return button doesn't work
	
func _on_Return_pressed():
	self.queue_free()
