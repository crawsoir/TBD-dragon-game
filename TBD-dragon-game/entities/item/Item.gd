extends KinematicBody2D

# Class for managing interactable items within the 2D environment

# Declare member variables here. Examples:
export var sprite_path = "res://entities/item/assets/DefaultItem.png"
var can_interact = false
export var item_name = "DEFAULT"

const GRAVITY = 1400
const MAX_FALL_SPEED = 2000
export var has_gravity = true
var velocity = Vector2.ZERO

func _physics_process(delta):	
	# gravity
	if velocity.y < MAX_FALL_SPEED and has_gravity:
		velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)

# Called when the node enters the scene tree for the first time.
func _ready():
	var sprite_texture = load(sprite_path)
	$Sprite.set_texture(sprite_texture)

func on_successful_pickup():
	pass

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pickup") and can_interact:
		var player = get_tree().get_root().find_node("Player", true, false)
		if player.add_item(item_name):
			on_successful_pickup()
			self.queue_free()
		else:
			print("Bag Full! Or Can't Pick up Item!")

func _on_InteractionArea2D_body_entered(body):
	if body.name == 'Player':
		can_interact = true


func _on_InteractionArea2D_body_exited(body):
	if body.name == 'Player':
		can_interact = false
