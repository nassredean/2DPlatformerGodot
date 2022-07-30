extends KinematicBody2D

enum Direction {LEFT, RIGHT}

# Movement
var speed : int = 100
var jump_speed : int = 220
var gravity : int = 660
var velocity = Vector2.ZERO
var initial_position = Vector2.ZERO

# Character state
var respawning = false
var slashing = false

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
			set_direction(Direction.RIGHT)
			velocity.x += speed
			if is_on_floor():
				$AnimationPlayer.play("Walk_Right")
			
		if Input.is_action_pressed("move_left"):
			set_direction(Direction.LEFT)
			velocity.x -= speed
			if is_on_floor():
				$AnimationPlayer.play("Walk_Right")

		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				velocity.y -= jump_speed
				# Stop the running/idle animations when jumping
				$AnimationPlayer.stop()
				$AnimationPlayer.seek(2, true)
		
		if Input.is_action_just_pressed("interact"):
			if is_on_floor():
				slashing = true
				$AnimationPlayer.play("Slash")
				
		# Play idle animation when not moving		
		if velocity.x == 0 and velocity.y == 0 && !slashing:
			$AnimationPlayer.play("Idle")
			
		#gravity
		velocity.y += gravity * delta

		# apply movement
		velocity = move_and_slide(velocity, Vector2.UP)

func respawn():
	position = initial_position
	respawning = false
	
func set_direction(direction):
	if direction == Direction.LEFT:
		$CharacterSprite.set_flip_h(true)
	elif direction == Direction.RIGHT:
		$CharacterSprite.set_flip_h(false)

func process_collisions():
	# get collisioins
	for i in get_slide_count():
		var col = get_slide_collision(i)
		if col.collider.is_in_group("spike") && !respawning:
			respawning = true
			get_node("/root/Main/HealthBar").do_damage(1)
			$AnimationPlayer.play("Death")
			break

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death":
		respawn()
	if anim_name == "Slash":
		slashing = false
