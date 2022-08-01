extends Sprite

enum Direction {LEFT, RIGHT}

var side = Direction.LEFT

export(Array, NodePath) var activateable_paths
var activateables = []

func _ready():
	get_tree().get_current_scene().register_respawnable(self)
	frame = 265
	
	for activateable_path in activateable_paths:
		activateables.append(get_node(activateable_path))
	
func interact():
	if side == Direction.LEFT:
		$AnimationPlayer.play("SwitchLeftToRight")
		side = Direction.RIGHT
	else:
		$AnimationPlayer.play("SwitchRightToLeft")
		side = Direction.LEFT

func respawn():
	side = Direction.LEFT
	frame = 265

func _on_AnimationPlayer_animation_finished(anim_name):
	if len(activateables) > 0:
		for activateable in activateables:
			activateable.activate()

func _on_Area2D_area_entered(area):
	area.get_parent().register_interactable(self)

func _on_Area2D_area_exited(area):
	area.get_parent().unregister_interactable()
