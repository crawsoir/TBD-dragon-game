extends ColorRect

export var dialoguePath = ""
export var imgPath = ""
export var audioPath = ""
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
	get_tree().paused = true
	
	$Indicator.visible = finished
	if Input.is_action_just_pressed("interact"):
		if finished:
			nextPhrase()
		else:    
			$Text.visible_characters = len($Text.text)
	
func getDialogue() -> Array:
	var f = File.new()
	assert(f.file_exists(dialoguePath), "File path does not exist: " +dialoguePath)
	
	f.open(dialoguePath, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
		
func nextPhrase() -> void:
	if phraseNum >= len(dialogue):
		get_tree().paused = false
		queue_free()
		return
	
	finished = false
	
	$Name.bbcode_text = dialogue[phraseNum]["Name"]
	$Text.bbcode_text = dialogue[phraseNum]["Text"]
	
	$Text.visible_characters = 0
	
	var f = File.new()
	
	var img_position = "left"
	if dialogue[phraseNum].has("Position"):
		img_position = dialogue[phraseNum]["Position"].to_lower()
	
	#TODO: this could be broken up into smaller functions
	# loading portrait image
	var img = imgPath + dialogue[phraseNum]["Name"] + dialogue[phraseNum]["Emotion"] + ".png"
	if f.file_exists(img):
		$Portrait.texture = load(img)
		
		match img_position:
			"right":
				$Portrait.flip_h = true
				$Portrait.position.x = 550
			_:
				$Portrait.flip_h = false
				$Portrait.position.x = 173
		
	else:
		$Portrait.texture = null
		print("not found " + img)
	
	#TODO: localize sound effects in json, like with images
	# loading dialogue sound effect
	var sound = audioPath + dialogue[phraseNum]["Sound"] + ".wav"
	if f.file_exists(audioPath):
		$AudioStreamPlayer.stream = load(audioPath)
	else:
		$AudioStreamPlayer.stream = null
		print("not found " + sound)
		
	while $Text.visible_characters < len($Text.text):
		$Text.visible_characters += 1
		
		# play audio
		if not $AudioStreamPlayer.stream == null:
			$AudioStreamPlayer.playing = true
			$AudioStreamPlayer.volume_db = rand_range(-20,-15)
		
		$Timer.start()
		yield($Timer, "timeout")
		
	finished = true 
	phraseNum += 1
	return
