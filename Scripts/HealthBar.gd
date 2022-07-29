extends CanvasLayer

export var maximum_health = 4
export var pip_size = 32

var current_health;
var pip_container;

var health_pip;

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = maximum_health;
	pip_container = get_node("Control/HBoxContainer")
	pip_container.rect_size = Vector2(maximum_health * pip_size, pip_size)
	var health_pip = preload("res://Scenes/HealthPip.tscn")
	
	for i in range(0, maximum_health):
		var pi = health_pip.instance()
		pi.name = "pip%s" % i
		pip_container.add_child(pi)

func do_damage(damage):
	for i in range(max(current_health - damage, 0), current_health):
		pip_container.get_node("pip%s" % i).queue_free()
		var damage_pip = load("res://Scenes/DamagePip.tscn")
		var pi = damage_pip.instance()
		pip_container.add_child(pi)
	current_health -= damage
	if current_health <= 0:
		# implement death functionality
		pass
