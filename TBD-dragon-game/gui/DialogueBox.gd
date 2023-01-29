extends ColorRect

export var dialoguePath = ""
export var imgPath = ""
export(float) var textSpeed = 0.05

var dialogue

var phraseNum = 0
var finished = false

func _ready():
	$Timer.wait_time = textSpeed
	dialogue = getDialogue()
	assert(dialogue, "Dialogue not found")
	nextPhrase()
	
func _process(delta):
	$Indicator.visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			nextPhrase()
		else:
			$Text.visible_characters = len($Text.text)
	
func getDialogue() -> Array:
	var f = File.new()
	assert(f.file_exists(dialoguePath), "File path does not exist" +dialoguePath)
	
	f.open(dialoguePath, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
		
func nextPhrase() -> void:
	if phraseNum >= len(dialogue):
		queue_free()
		return
	
	finished = false
	
	$Name.bbcode_text = dialogue[phraseNum]["Name"]
	$Text.bbcode_text = dialogue[phraseNum]["Text"]
	
	$Text.visible_characters = 0
	
	var f = File.new()
	var img = imgPath + dialogue[phraseNum]["Name"] + dialogue[phraseNum]["Emotion"] + ".png"
	if f.file_exists(img):
		$Portrait.texture = load(img)
	else:
		$Portrait.texture = null
		print("not found " + img)
		
	while $Text.visible_characters < len($Text.text):
		$Text.visible_characters += 1
		
		$Timer.start()
		yield($Timer, "timeout")
		
	finished = true 
	phraseNum += 1
	return
