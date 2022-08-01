extends Area2D

enum Direction {LEFT, RIGHT}

var side = Direction.LEFT

func switch():
	if side == Direction.LEFT:
		$AnimationPlayer.play("SwitchLeftToRight")
		side = Direction.RIGHT
	else:
		$AnimationPlayer.play("SwitchRightToLeft")
		side = Direction.LEFT
