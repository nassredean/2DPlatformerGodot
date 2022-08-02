extends KinematicBody2D

class_name Character

enum Direction {LEFT, RIGHT}

# Movement
var horizontal_speed : int = 100
var jump_speed : int = 220
var terminal_velocity : int = 350

var gravity : int = 660
var velocity = Vector2.ZERO
var initial_position = Vector2.ZERO

# Character state
var dieing = false
var interacting = false
var current_interactable = null;
var external_forces = {}

func respawn():
	interacting = false
	dieing = false
	unregister_interactable()
	external_forces = {}
	position = initial_position
	
func register_interactable(interactable):
	current_interactable = interactable
	
func unregister_interactable():
	current_interactable = null;
	
func register_external_force(force_name, force, active = false):
	external_forces[force_name] = {
		"force": force,
		"active": active
	}

func unregister_external_force(force_name):
	external_forces.erase(force_name)

func activate_external_force(force_name):
	external_forces[force_name]["active"] = true

func deactivate_external_force(force_name):
	external_forces[force_name]["active"] = false

func _ready():
	get_tree().get_current_scene().register_respawnable(self)
	initial_position = position
	
func _physics_process(delta):
	_get_input(delta)
	_process_collisions()

func _get_input(delta):
	if !dieing:
		velocity.x = 0
		if Input.is_action_pressed("move_right"):
			interacting = false;
			_set_direction(Direction.RIGHT)
			velocity.x += horizontal_speed
			if is_on_floor():
				$AnimationPlayer.play("Walk_Right")
			
		if Input.is_action_pressed("move_left"):
			interacting = false;
			_set_direction(Direction.LEFT)
			velocity.x -= horizontal_speed
			if is_on_floor():
				$AnimationPlayer.play("Walk_Right")

		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				interacting = false;
				velocity.y -= jump_speed
				# Stop the running/idle animations when jumping
				$AnimationPlayer.stop()
				$AnimationPlayer.seek(2, true)
		
		if Input.is_action_just_pressed("interact"):
			if is_on_floor():
				interacting = true
				$AnimationPlayer.play("Slash")
				if current_interactable:
					current_interactable.interact()
				
		# Play idle animation when not moving		
		if velocity.x == 0 and velocity.y == 0 && !interacting:
			$AnimationPlayer.play("Idle")
		
		# apply external forces
		for external_force_name in external_forces:
			var external_force = external_forces[external_force_name]
			if external_force["active"]:
				velocity = external_force["force"].apply_force(velocity)
		
		# apply gravity
		velocity.y += gravity * delta
		
		# apply terminal velocity
		if velocity.y > 0:
			velocity.y = min(velocity.y, terminal_velocity)

		# apply movement
		velocity = move_and_slide(velocity, Vector2.UP)

func _set_direction(direction):
	if direction == Direction.LEFT:
		$CharacterSprite.set_flip_h(true)
	elif direction == Direction.RIGHT:
		$CharacterSprite.set_flip_h(false)

func _process_collisions():
	# get collisioins
	for i in get_slide_count():
		var col = get_slide_collision(i)
		if col.collider.is_in_group("spike") && !dieing:
			dieing = true
			get_node("/root/LevelOne/HealthBar").do_damage(1)
			$AnimationPlayer.play("Death")
			break

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death":
		get_parent().respawn()
	if anim_name == "Slash":
		interacting = false
