extends CanvasLayer

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true

func _on_Yes_pressed():
	Global.move_to_area("CAVE","DefaultSpawn")
	get_tree().paused = false
	queue_free()

func _on_No_pressed():
	get_tree().paused = false
	queue_free()


func _on_button_mouse_entered():
	$AudioStreamPlayer.play()
