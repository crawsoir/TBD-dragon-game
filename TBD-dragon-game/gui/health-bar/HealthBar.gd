extends CanvasLayer


var max_health = 5
var current_health = 5
const HEART = preload("res://gui/health-bar/Heart.tscn")
var heart_list = []

# Called upon entering the scene tree
func _ready():
	for i in range(max_health):
		var new_heart = HEART.instance()
		heart_list.append(new_heart)
		if i+1 <= current_health:
			new_heart.texture = new_heart.FULL
		else:
			new_heart.texture = new_heart.EMPTY
		$HeartsGrid.add_child(new_heart)

func refresh_hearts_gui():
	for i in range(max_health):
		if i+1 <= current_health:
			heart_list[i].set_full()
		else:
			heart_list[i].set_empty()
			
func on_health_update(new_max_health, new_current_health):
	# Adjust maximum hearts if necessary
	if new_max_health > max_health:
		for i in range(max_health, new_max_health):
			var new_heart = HEART.instance()
			heart_list.append(new_heart)
			$HeartsGrid.add_child(new_heart)
	elif new_max_health < max_health:
		for i in range(max_health-1, new_max_health-2, -1):
			var cur_heart = heart_list[i]
			heart_list.pop_back()
			cur_heart.queue_free()
	# Repaint Hearts
	max_health = new_max_health
	current_health = new_current_health
	self.refresh_hearts_gui()
