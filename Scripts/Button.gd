extends Sprite

enum Status {ON, OFF}

var status = Status.OFF

export(Array, NodePath) var activateable_paths
var activateables = []

func _ready():
	get_tree().get_current_scene().register_respawnable(self)
	frame = 356
	
	for activateable_path in activateable_paths:
		activateables.append(get_node(activateable_path))

func respawn():
	status = Status.Off
	frame = 356

func _on_Area2D_area_entered(area):
	$AnimationPlayer.play("UpToDown")

func _on_Area2D_area_exited(area):
	$AnimationPlayer.play("DownToUp")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "UpToDown":
		status = Status.ON
		for activateable in activateables:
			activateable.activate()
	if anim_name == "DownToUp":
		status = Status.OFF
