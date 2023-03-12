extends KinematicBody2D

enum {
	IDLE,
	SWITCH,
	TRANSFORM,
	ATTACK,
}

var state = IDLE
var gravity = 10
var speed = 0.1
var health = 4
var velocity = Vector2(0, 0)
var accel = Vector2(0, 0)

var target = null

func _ready():
	$IdleTimer.wait_time = 2
	$IdleTimer.start()
	$AnimationPlayer.current_animation = "IdleLeft"


func _process(delta):
		
	if $RayCast2D.is_colliding():
		var obj = $RayCast2D.get_collider()
		if obj.name == "Player":
			state = TRANSFORM
			$AudioStreamPlayer2D.play()
			target = obj
	
	if health < 0:
		queue_free()
		
	if $DmgTimer.is_stopped():
		modulate = Color(1,1,1)	
	
	match state:
		IDLE:
			if not is_on_floor():
				velocity.y += gravity * delta
			if $IdleTimer.is_stopped():
				if $AnimationPlayer.current_animation == "IdleLeft":
					$AnimationPlayer.current_animation = "SwitchRight"
				else:
					$AnimationPlayer.current_animation = "SwitchLeft"
				state = SWITCH
				
			velocity = move_and_slide(velocity, Vector2.UP)
		SWITCH:
			pass
		TRANSFORM:
			$AnimationPlayer.current_animation = "Transform"
		ATTACK:
			$AnimationPlayer.current_animation = "Attack"
			accel = (target.position - position).normalized()
			if target.position.distance_to(position) > 200:
				velocity = accel*speed*25
			else:
				velocity += accel*speed
			position += velocity


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "SwitchRight" or anim_name == "SwitchLeft":
		if anim_name == "SwitchRight":
			$AnimationPlayer.current_animation = "IdleRight"
		else:
			$AnimationPlayer.current_animation = "IdleLeft"
		state = IDLE
		$IdleTimer.start()
	elif anim_name == "Transform":
		$AudioStreamPlayer2D.stop()
		state = ATTACK


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.take_damage(1)
		
func take_damage(dmg):
	health -= dmg
	modulate = Color(1,0,0)	
	$DmgTimer.wait_time = 0.2
	$DmgTimer.start()

	
	
