extends Sprite

enum Status {EMPTY, CHARGING}
var status = Status.EMPTY
var timeable = null;

func _ready():
	get_tree().get_current_scene().register_respawnable(self)
	timeable = get_parent()
	
func start():
	$AnimationPlayer.play("Charge")
	
func respawn():
	status = Status.EMPTY
	frame = 324

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Charge":
		timeable.timer_finished()
		frame = 324
