extends KinematicBody2D

enum {
	IDLE,
	SWITCH,
	TRANSFORM,
	ATTACK,
}

var state = IDLE
var gravity = 10
var speed = 2
var health = 4
var velocity = Vector2(0, 0)
var accel = Vector2(0, 0)

var target = null
var target_in_collision = false

func _ready():
	$IdleTimer.wait_time = 2
	$IdleTimer.start()
	
	$DmgTimer.wait_time = 1
	
	$AnimationPlayer.current_animation = "IdleLeft"


func _physics_process(delta):
		
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
			set_collision_layer_bit(4, true)
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
			set_collision_layer_bit(4, false)
		ATTACK:
			$AnimationPlayer.current_animation = "Attack"
			accel = (target.position - position).normalized()
			
			var distance_to_target = target.position.distance_to(position)
			if distance_to_target > 250:
				velocity = accel*speed*(distance_to_target/3)
			else:
				velocity += accel*speed*0.5
			move_and_slide(velocity)
			
			if target_in_collision and $DmgTimer.is_stopped():
				target.take_damage(1)
				$DmgTimer.start()


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
		target_in_collision = true
		body.take_damage(1)
		$DmgTimer.start()

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		target_in_collision = false
		$DmgTimer.stop()
		
		
func take_damage(dmg):
	health -= dmg
	modulate = Color(1,0,0)	
	$DmgTimer.wait_time = 0.2
	$DmgTimer.start()
