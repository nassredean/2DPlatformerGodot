extends KinematicBody2D

enum Status {UP, DOWN}
var status = Status.DOWN

const EMPTY_FRAME = 1023

func _ready():
	get_tree().get_current_scene().register_respawnable(self)

func respawn():
	status = Status.DOWN
	$BoxSprite.frame = 161
	$PlatformSprite.frame = EMPTY_FRAME

func activate():
	$Timer.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "DownToUp":
		$AnimationPlayer.play("UpToDown")
	if anim_name == "UpToDown":
		status = Status.DOWN

func timer_finished():
	$AnimationPlayer.play("DownToUp")
	status = Status.UP
