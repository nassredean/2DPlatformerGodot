extends KinematicBody2D

# Movement
var speed : int = 100
var jump_speed : int = 220
var gravity : int = 660
var velocity = Vector2.ZERO
var initial_position = Vector2.ZERO

# Character state
var respawning = false

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = position

func _physics_process(delta):
	get_input(delta)
	process_collisions()

func get_input(delta):
	if !respawning:
		velocity.x = 0
		if Input.is_action_pressed("move_right"):
			$RunIdleSwipeSprite.set_flip_h(false)
			velocity.x += speed
			if is_on_floor():
				$AnimationPlayer.play("Walk_Right")
			
		if Input.is_action_pressed("move_left"):
			$RunIdleSwipeSprite.set_flip_h(true)
			velocity.x -= speed
			if is_on_floor():
				$AnimationPlayer.play("Walk_Right")

		if Input.is_action_pressed("jump"):
			if (is_on_floor()):
				velocity.y -= jump_speed
				# Stop the running/idle animations when jumping
				$AnimationPlayer.stop()
				$AnimationPlayer.seek(2, true)
				
		# Play idle animation when not moving		
		if velocity.x == 0 and velocity.y == 0:
			$AnimationPlayer.play("Idle")
			
		#gravity
		velocity.y += gravity * delta

		# apply movement
		velocity = move_and_slide(velocity, Vector2.UP)

func respawn():
	position = initial_position
	respawning = false

func process_collisions():
	# get collisioins
	for i in get_slide_count():
		var col = get_slide_collision(i)
		if col.collider.is_in_group("spike"):
			get_node("/root/Main/HealthBar").do_damage(1)
			respawning = true
			$AnimationPlayer.play("Death")
			break

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death":
		respawn()
