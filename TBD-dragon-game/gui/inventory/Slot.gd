extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const regular_box = preload("res://gui/inventory/assets/slot.png")
const highlighted_box = preload("res://gui/inventory/assets/slot_selected.png")

var style = StyleBoxTexture.new()
var item # Ex {Name: QuestItem1, count: 1}
var index # A string representing a number that is the index. 
signal left_click
signal right_click

func _ready():
	$ItemPanel.set("custom_styles/panel", style)
	
	# Because the children don't resize with the parents ... 
	$TextureRect.rect_size.x = self.rect_size.x
	$TextureRect.rect_size.y = self.rect_size.y
	$ItemPanel.rect_size.x = self.rect_size.x
	$ItemPanel.rect_size.y = self.rect_size.y

func set_text():
	if item:
		$Amount.text = str(item["count"])
	else:
		$Amount.text = ""

func set_item(inv_item):
	item = inv_item
	set_text()

func change_texture(texture):
	style.texture = texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func highlight():
	$TextureRect.texture = highlighted_box

func unhighlight():
	$TextureRect.texture = regular_box

func _on_ItemPanel_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			emit_signal("left_click", get_global_mouse_position())
			print("Left clicked " + get_name() + "!" )
		elif event.button_index == BUTTON_RIGHT && event.pressed:
			emit_signal("right_click", get_global_mouse_position())
			print("Right clicked " + get_name() + "!" )
