extends TextureRect

var full_texture
var empty_texture

func _ready():
	full_texture = texture

	empty_texture = ImageTexture.new()
	var empty_image = Image.new()
	empty_image.load("res://Assets/damagepip.png")
	empty_texture.create_from_image(empty_image)
	
# Called when the node enters the scene tree for the first time.
func set_status(status):
	if status == 0:
		texture = empty_texture
	elif status == 1:
		texture = full_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
