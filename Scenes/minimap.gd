extends Control

const SIZE = 128
var WALL_COLOR = Color.from_string("#8f5e3c", Color.BLACK)

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
	
 
func trace(node: Node2D, color: Color):
	entities[id] = [node, color]
	id += 1

func set_pixel(p: Vector2i, color: Color):
	if not(p.x < 0 or p.x > SIZE-1 or p.y < 0 or p.y > SIZE-1):
		image.set_pixel(p.x,p.y, color)
	for i in [Vector2i.LEFT, Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT]:
		var q = p+i
		if not (q.x < 0 or q.x > SIZE-1 or q.y < 0 or q.y > SIZE-1):
			if image.get_pixel(q.x, q.y) == Color.TRANSPARENT:
				image.set_pixel(q.x, q.y, color.darkened(0.4))
	

func regenerate():
	image.fill(Color.TRANSPARENT)
	
	if not is_instance_valid(tilemap) or not is_instance_valid(camera):
		return
	
	var pos := tilemap.local_to_map(camera.position)
	for y in range(SIZE):
		for x in range(SIZE):
			var v = pos - Vector2i(x-SIZE/2, y-SIZE/2)
			if tilemap.get_cell_source_id(0, v) >= 0:
				set_pixel(Vector2i(x,y), WALL_COLOR)
	
	for i in entities.keys():
		if not is_instance_valid(entities[i][0]):
			entities.erase(i)
			continue
		
		var p = tilemap.local_to_map(camera.global_position - entities[i][0].global_position)
		set_pixel(Vector2i(p.x+SIZE/2,p.y+SIZE/2), entities[i][1])
	
	texture.update(image)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	regenerate()

func _on_timer_timeout():
	regenerate()
