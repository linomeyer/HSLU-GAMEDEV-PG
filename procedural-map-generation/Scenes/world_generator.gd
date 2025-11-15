extends Node2D

@export var width = 600
@export var height = 200
@onready var tilemap = $TileMap
var temperature = {}
var altitude = {}
var biome = {}
var simplexNoise = FastNoiseLite.new()


func generate_map(per, oct):
	simplexNoise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	simplexNoise.seed = randi()
	simplexNoise.period = per
	simplexNoise.fractal_octaves = oct
	
	var grid = {}
	for x in width:
		for y in height:
			var rand := (float) (2*(abs(simplexNoise.get_noise_2d(x,y))))
			grid[Vector2(x,y)] = rand
	
	return grid
	
