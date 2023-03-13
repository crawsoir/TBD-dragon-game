extends "res://entities/npc/npc.gd"

var player = null

func display_correct_dialogue():
	var quest = Global.quest_progress["test_quest"]
	var quest_status = quest["Status"]
	var items_required = quest["Items"]
	var rewards = quest["Rewards"]
	
	if quest_status == Global.NEW_QUEST:
		Global.get_dialogue("TestQuestNewQuest.json")
		quest["Status"] = Global.IPR_QUEST
	elif quest_status == Global.IPR_QUEST:
		for item in items_required:
			var count = items_required[item]
			if not player.get_number_of_item(item) >= count:
				Global.get_dialogue("TestQuestIPRQuest.json")
				return
		Global.get_dialogue("TestQuestDoneQuest.json")
		# Remove items
		for item in items_required:
			var count = items_required[item]
			player.remove_items(item, count)
			
		# Add rewards. TODO: need to check if inventory is too full
		for item in rewards:
			var count = rewards[item]
			player.add_items(item, count)
		
		# Set quest to done
		quest["Status"] = Global.DONE_QUEST
	else:
		Global.get_dialogue("TestQuestNoQuest.json")
		
func _input(event):
	# print("function overriden input")
	if Input.is_action_just_pressed("interact") and can_interact:
		can_interact = false
		$HoverSprite.visible = false
		display_correct_dialogue()
		
func _on_Area2D_body_entered(body):
	# print("function overriden enter")
	if body.name == 'Player':
		can_interact = true
		$HoverSprite.playing = true
		player = body

func _on_Area2D_body_exited(body):
	# print("function overriden exit")
	if body.name == 'Player':
		$HoverSprite.playing = false
		$HoverSprite.frame = 0
		can_interact = false
		player = null
