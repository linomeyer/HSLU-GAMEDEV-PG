extends Node2D

@export var noise_height_texture: NoiseTexture2D
@export var noise_tree_texture: NoiseTexture2D

@export var tree_noise_threshold = 0.8
@export var grass_noise_threshold = 0.2
@export var sand_noise_threshold = 0.0
@export var cliff_noise_threshold = 0.4

@onready var water: TileMapLayer = $water
@onready var ground1: TileMapLayer = $ground1
@onready var ground2: TileMapLayer = $ground2
@onready var environment: TileMapLayer = $environment
@onready var cliff: TileMapLayer = $cliff
@onready var camera_2d: Camera2D = $Player/Camera2D

var source_id = 0
var water_atlas = Vector2i(0,1)
var land_atlas = Vector2i(0,0)
var palm_tree_atlas = [Vector2i(12,2), Vector2i(15,2)]
var oak_tree_atlas = Vector2i(15,6)

var sand_tiles = []
var terrain_sand = 3

var grass_tiles = []
var terrain_grass = 1
var grass_atlas = [Vector2i(1,0), Vector2i(2,0), Vector2i(3,0), Vector2i(4,0), Vector2i(5,0)]

var cliff_tiles = []
var terrain_cliff = 4


var noise: FastNoiseLite
var tree_noise: FastNoiseLite

var width: int = 500
var height: int = 500

func _ready():
	noise = noise_height_texture.noise
	tree_noise = noise_tree_texture.noise
	generate_world()
	
func _input(event):
	if Input.is_action_just_pressed("zoom_in"):
		var zoom = camera_2d.zoom.x + 0.1
		camera_2d.zoom = Vector2(zoom, zoom)
		
		
	if Input.is_action_just_pressed("zoom_out"):
		var zoom = camera_2d.zoom.x - 0.1
		camera_2d.zoom = Vector2(zoom, zoom)
		
	
func generate_world():
	noise.seed = randi()
	tree_noise.seed = randi()
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var noise_val = noise.get_noise_2d(x,y)
			var tree_noise_val = tree_noise.get_noise_2d(x,y)
			var pos = Vector2i(x,y)
			
			#ground
			if noise_val >= sand_noise_threshold:
				if noise_val > 0.05 and noise_val < 0.175 and tree_noise_val > tree_noise_threshold:
					environment.set_cell(pos, source_id, palm_tree_atlas.pick_random())
				if noise_val > grass_noise_threshold:
					grass_tiles.append(pos)
					if noise_val > grass_noise_threshold + 0.05:
						if noise_val < 0.35 and tree_noise_val > tree_noise_threshold:
							environment.set_cell(pos, source_id, oak_tree_atlas)
						ground2.set_cell(pos, source_id, grass_atlas.pick_random())
				if noise_val > cliff_noise_threshold:
					cliff_tiles.append(pos)
					
				sand_tiles.append(pos)
				
			#water
			water.set_cell(pos, source_id, water_atlas)
			
	ground1.set_cells_terrain_connect(sand_tiles, terrain_sand, 0)
	ground1.set_cells_terrain_connect(grass_tiles, terrain_grass, 0)
	cliff.set_cells_terrain_connect(cliff_tiles, terrain_cliff, 0)
			
