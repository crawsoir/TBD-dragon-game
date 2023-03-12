extends CanvasLayer

func _on_Yes_pressed():
	Global.move_to_area("CAVE","DefaultSpawn")
	queue_free()

func _on_No_pressed():
	queue_free()
