extends KinematicBody2D

enum {
	WALK,
	IDLE,
	ATTACK,
	HIT
}

var gravity = 10
var velocity = Vector2(0, 0)
var speed = 50

var is_moving_left = false
var health = 3
var state = WALK

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	$IdleTimer.start()
	$IdleTimer.wait_time = 5

func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if $DmgTimer.is_stopped():
		modulate = Color(1,1,1)	
	
	match state:
		IDLE:
			if $IdleTimer.is_stopped():
				state = WALK
				$IdleTimer.start()
			velocity.x = 0
			$AnimationPlayer.current_animation = "Idle"
		WALK:
			if $IdleTimer.is_stopped():
				state = IDLE
				$IdleTimer.start()
			$AnimationPlayer.current_animation = "Walk"
			velocity.x = speed if is_moving_left else -speed
			detect_turn_around()
		ATTACK:
			velocity.x = 0
			$AnimationPlayer.current_animation = "Attack"
		HIT:
			velocity.x = 0
			$AnimationPlayer.current_animation = "Hit"
			if health < 0:
				queue_free()
			
	velocity = move_and_slide(velocity, Vector2.UP)

func detect_turn_around():
	if (not $DownRayCast2D.is_colliding() and is_on_floor()) or $FrontRayCast2D.is_colliding():
		is_moving_left = !is_moving_left
		scale.x = -scale.x

func _on_PlayerDetector_body_entered(body):
	if body.name == "Player":
		state = ATTACK
		
func _on_PlayerDetector_body_exited(body):
	if body.name == "Player":
		state = WALK

func _on_AttackDetector_body_entered(body):
	if body.name == "Player":
		body.take_damage(1)

func _on_PlayerNearbyDetector_body_entered(body):
	if body.name == "Player":
		state = WALK

func _on_PlayerNearbyDetector_body_exited(body):
	if body.name == "Player":
		state == IDLE
		
func take_damage(dmg):
	health -= dmg
	state = HIT
	modulate = Color(1,0,0)	
	$DmgTimer.wait_time = 0.2
	$DmgTimer.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hit":
		state = WALK
