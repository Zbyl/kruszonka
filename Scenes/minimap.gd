extends Control

const SIZE = 128

@export var tilemap: TileMap
@export var camera: Node2D

var image := Image.create(SIZE, SIZE, false, Image.FORMAT_RGBA8)
@onready var texture: ImageTexture = ImageTexture.create_from_image(image)

var id := 0

## An array of all traced entity (id -> )
var entities: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	regenerate()
	$TextureRect.texture = texture
	
 
#func trace(node: Node2D, color: Color):
#	entities[id] = node
#	node.

func regenerate():
	image.fill(Color.TRANSPARENT)
	
	if not is_instance_valid(tilemap) or not is_instance_valid(camera):
		return
		
	print("regenerating")
	
	var pos := tilemap.local_to_map(camera.position)
	for y in range(SIZE):
		for x in range(SIZE):
			var v = pos - Vector2i(x-SIZE/2, y-SIZE/2)
			if tilemap.get_cell_source_id(0, v) >= 0:
				image.set_pixel(x,y, Color.INDIGO)
	
	texture.update(image)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	regenerate()
