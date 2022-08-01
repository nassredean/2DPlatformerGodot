extends KinematicBody2D

enum Status {UP, DOWN}

export(Status) var status = Status.DOWN

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_current_scene().register_respawnable(self)
	
	if status == Status.UP:
		$Sprite.frame = 352
		$CollisionShape2D.visible = true
	else:
		$Sprite.frame = 355
		$CollisionShape2D.visible = false

func activate():
	if status == Status.UP:
		$AnimationPlayer.play("UpToDown")
		status = Status.DOWN
	else:
		$AnimationPlayer.play("DownToUp")
		status = Status.UP

func respawn():
	status = Status.DOWN
	$Sprite.frame = 355
