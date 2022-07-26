extends KinematicBody2D

var speed : int = 100
var jump_speed : int = 220
var gravity : int = 660
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	get_input(delta)

func get_input(delta):
	velocity.x = 0
	if Input.is_action_pressed("move_right"):
		$Sprite.set_flip_h(false)
		velocity.x += speed
		if is_on_floor():
			$AnimationPlayer.play("Walk_Right")
		
	if Input.is_action_pressed("move_left"):
		$Sprite.set_flip_h(true)
		velocity.x -= speed
		if is_on_floor():
			$AnimationPlayer.play("Walk_Right")

	if Input.is_action_pressed("jump"):
		if (is_on_floor()):
			velocity.y -= jump_speed
			
	# Play idle animation when not moving		
	if velocity.x == 0 and velocity.y == 0:
		$AnimationPlayer.play("Idle")
	
	# Stop animation when in the air
	if !is_on_floor():
		$AnimationPlayer.stop()
		$AnimationPlayer.seek(2, true)
		
	#gravity
	velocity.y += gravity * delta
	
	# apply movement
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# get collisioins
	for i in get_slide_count():
		var col = get_slide_collision(i)
		if col.collider.is_in_group("spike"):
			# do damage to player
			pass
