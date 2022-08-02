extends KinematicBody2D

enum Status {UP, DOWN}
const EMPTY_FRAME = 1023

export var jump_force = 400

var status = Status.DOWN
var active_player = null

func respawn():
	status = Status.DOWN
	active_player = null
	$BoxSprite.frame = 161
	$PlatformSprite.frame = EMPTY_FRAME
	$BoxCollisionShape.position.y = -14.5
	
func activate():
	$Timer.start()

func timer_finished():
	$AnimationPlayer.play("DownToUp")
	status = Status.UP

func apply_force(velocity):
	velocity.y -= jump_force
	return velocity

func _ready():
	get_tree().get_current_scene().register_respawnable(self)
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "DownToUp":
		if active_player:
			active_player.activate_external_force("jump_platform")
		$AnimationPlayer.play("UpToDown")
	if anim_name == "UpToDown":
		status = Status.DOWN

func _on_Area2D_area_entered(area):
	active_player = area.get_parent()
	active_player.register_external_force("jump_platform", self)

func _on_Area2D_area_exited(area):
	active_player = null
	area.get_parent().unregister_external_force("jump_platform")
