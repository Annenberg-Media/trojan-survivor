extends TileMap

var moisture = FastNoiseLite.new()  # x offset
var temperature = FastNoiseLite.new()  # y offset
var altitude = FastNoiseLite.new()  # for creating bricks

# CHUNK DIMENSIONS
var width = 32
var height = 32

# get_tree().current_scene returns reference to ROOT NODE of currently active scene
@onready var player = get_tree().current_scene.get_node("Player")

# array of positions where we have tiles (used for de-loading) 
var loaded_chunks = []

func _ready() -> void:
	# setting seeds for randoms
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	
	# "smoothness" of terrain Perlin noise! 
	# i.e. larger chunks/smoother land
	altitude.frequency = 0.01
	
func _process(delta: float) -> void:
	# local_to_map() returns MAP coordinates of the cell containing the given local_position 
	# has to be LOCAL position, relative to TileMap node! 
	# "given this pixel position over the TileMap, which tile cell is that over?"
	var player_tile_pos = local_to_map(to_local(player.global_position))
	generate_chunk(player_tile_pos)
	unload_distant_chunks(player_tile_pos)
	
func generate_chunk(pos):
	# generate noise for chunk around passed coordinate
	
	# iterate through each space in chunk
	for x in range(width):
		for y in range(height):
			# generate noise values for moisture, temperature, altitude 
			# get_noise_2d() returns single 2D NOISE VALUE, -1 to 1, at given position!
			var moist = moisture.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10 
			var temp = temperature.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10 
			var alt = altitude.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10  
			
			if alt < 0:  # 0 an arbitrary value; in this case, same probabilities of getting brick or grass
				# for the last parameter, which actually selects the cell, 
				# "remap/offset" noise values from -10 to 10 into [0, 2] for col and [0, 1] for row 
				var noise_x = (moist + 10.0)/20.0
				var set_x
				if noise_x < 1.2/3.0:
					set_x = 0
				elif noise_x < 1.8/3.0:
					set_x = 1
				else:
					set_x = 2
				set_cell(0, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), 0, 
				Vector2i(set_x, 0))
			else: 
				# guarantees brick
				# print("DEBUG: drawing tile (", tile_to_set_x, ",", 1, ")")
				set_cell(0, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), 0, Vector2i(0, 1))
				
			if Vector2i(pos.x, pos.y) not in loaded_chunks:
				loaded_chunks.append(Vector2i(pos.x, pos.y))
				

func unload_distant_chunks(player_pos):
	var unload_dist = (width * 2) + 1
	for chunk in loaded_chunks:
		var dist_to_player = dist(chunk, player_pos)
		
		if dist_to_player > unload_dist:
			print("DEBUG: deleting chunk at ", chunk)
			clear_chunk(chunk)
			loaded_chunks.erase(chunk)


func clear_chunk(pos):
	for x in range(width):
		for y in range(height):
			set_cell(0, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), -1, Vector2(-1, -1))

func dist(p1, p2):
	var r = p1 - p2
	return sqrt(r.x**2 + r.y**2)
