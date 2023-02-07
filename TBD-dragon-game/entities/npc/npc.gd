extends KinematicBody2D

export var active_type = "talk"
export var has_gravity = true
export var dialogue_path = ""
export var wandering = true

var can_interact = false

var velocity = Vector2.ZERO

# basic wandering variables
var wander_timer = 300
var stop_timer = 0
var wander_velocity = 15

func _process(delta):
	if wandering:
		basic_npc_wander()
	
	if has_gravity and velocity.y < 2000:
		velocity.y += 1400 * delta
	velocity = move_and_slide(velocity, Vector2.UP, true)
	
	play_animation()
	
func basic_npc_wander():
	if wander_timer > 0:
		velocity.x = wander_velocity
		wander_timer -= 1
		stop_timer = 400
	elif stop_timer > 0:
		velocity.x = 0
		stop_timer -= 1
	else:
		wander_timer = 300
		wander_velocity = -wander_velocity

func play_animation():
	$HoverSprite.animation = active_type
	$HoverSprite.visible = can_interact
	
	if velocity.x != 0:
		$NpcSprite.animation = "walk"
	else:
		$NpcSprite.animation = "idle"
		
func _input(event):
	if Input.is_action_just_pressed("ui_accept") and can_interact:
		can_interact = false
		$HoverSprite.visible = false
		Global.goto_overlay(Global.DIALOGUE_BOX)
		
func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		can_interact = true
		$HoverSprite.playing = true

func _on_Area2D_body_exited(body):
	if body.name == 'Player':
		$HoverSprite.playing = false
		$HoverSprite.frame = 0
		can_interact = false
