extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_text(text):
	$Label.text = text


func _on_Button_pressed():
	queue_free()
