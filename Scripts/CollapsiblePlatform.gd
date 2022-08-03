extends KinematicBody2D

enum Status {UP, DOWN}

export(Status) var status = Status.DOWN

var initial_status = null

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_current_scene().register_respawnable(self)
	initial_status = status
	
	if status == Status.UP:
		$Sprite.frame = 352
		$CollisionShape2D.disabled = false
	else:
		$Sprite.frame = 355
		$CollisionShape2D.disabled = true

func activate():
	if status == Status.UP:
		$AnimationPlayer.play("UpToDown")
		status = Status.DOWN
	else:
		$AnimationPlayer.play("DownToUp")
		status = Status.UP

func respawn():
	if initial_status == Status.DOWN:
		status = Status.DOWN
		$CollisionShape2D.disabled = true
		$Sprite.frame = 355
	else:
		status = Status.UP
		$Sprite.frame = 352
		$CollisionShape2D.disabled = false
