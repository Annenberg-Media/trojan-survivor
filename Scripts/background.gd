extends Node2D

@onready var tilemap = $TileMap
@export var view_distance: int = 10
@export var chunk_size: int = 20
@export var tile_size: int = 16

var valid_id = []
var generated_chunks = {}
var random = RandomNumberGenerator.new()
var last_camera_chunk = Vector2i.ZERO

func _ready():
	random.randomize()
	var source = tilemap.tile_set.get_source(0)

	# Go through all tiles
	for x in range(source.get_atlas_grid_size().x):
		for y in range(source.get_atlas_grid_size().y):
			if source.has_tile(Vector2i(x, y)): valid_id.append(x)
		
	# Create 10 x 10 grid for 100 chunks 
	for x in range(-5, 5):
		for y in range(-5, 5): 
			generate_chunk(x, y)

func _process(_delta):
	var camera = get_viewport().get_camera_2d()
	
	# Update the chunks around camera
	update_chunks_around_camera(camera.global_position)

func update_chunks_around_camera(pos):
	var chunk_x = int(pos.x / (chunk_size * tile_size))
	var chunk_y = int(pos.y / (chunk_size * tile_size))
	
	# Updaate after moving to another chunk
	var current_chunk = Vector2i(chunk_x, chunk_y)
	if current_chunk == last_camera_chunk:
		return
	
	last_camera_chunk = current_chunk
	
	# Get chunk from view distance
	for x in range(chunk_x - view_distance, chunk_x + view_distance + 1):
		for y in range(chunk_y - view_distance, chunk_y + view_distance + 1):
			generate_chunk(x, y)
	
	# Deload chunks when too far away 
	var chunks_to_remove = []
	for chunk_key in generated_chunks:
		var coords = chunk_key.split(",")
		var x = int(coords[0])
		var y = int(coords[1])
		
		if abs(x - chunk_x) > view_distance + 5 or abs(y - chunk_y) > view_distance + 5:
			chunks_to_remove.append(chunk_key)
	
	# Remove the chunks
	for chunk_key in chunks_to_remove:
		deload_chunk(chunk_key)

func generate_chunk(chunk_x, chunk_y):
	var chunk_key = str(chunk_x) + "," + str(chunk_y)
	if generated_chunks.has(chunk_key): return
	
	# Chunk generated 
	generated_chunks[chunk_key] = true
	
	# Start position of chunk
	var start_pos = Vector2i(chunk_x * chunk_size, chunk_y * chunk_size)
	
	# Get chunk for each tile
	for x in range(chunk_size):
		for y in range(chunk_size):
			
			# Make sure we have valid tiles to choose from
			if valid_id.size() > 0:
				# Place a random tile from array
				var random_index = random.randi() % valid_id.size()
				var tile_id = valid_id[random_index]
				
				# Set the tile in the tilemap
				tilemap.set_cell(0, start_pos + Vector2i(x, y), 0, Vector2i(tile_id, 0))

func deload_chunk(chunk_key):
	var coords = chunk_key.split(",")
	var chunk_x = int(coords[0])
	var chunk_y = int(coords[1])
	
	# Start position of chunk
	var start_pos = Vector2i(chunk_x * chunk_size, chunk_y * chunk_size)
	
	# Clear tiles in chunk
	for x in range(chunk_size):
		for y in range(chunk_size):
			tilemap.erase_cell(0, start_pos + Vector2i(x, y))
	
	# Remove
	generated_chunks.erase(chunk_key)
