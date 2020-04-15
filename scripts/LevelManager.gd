extends Node2D

var rng = RandomNumberGenerator.new()
var level_block_count
var boss_interval = 5120
var boss_location = -boss_interval
var boss_battle= false
var cumulative_y = 0
var initial_camera_y
var margin_length = 128
var camera_movespeed = 50
var pause_camera = false

const tile_size = 64
onready var tilemap = $TileMap

func _ready():
	rng.randomize()
	level_block_count = AssetManager.level_blocks.size()
	GameManager.camera.movespeed = camera_movespeed
	initial_camera_y = GameManager.camera.position.y

func _process(delta):
	# stop camera if level block sets it so
	if pause_camera or boss_battle:
		if GameManager.camera.position.y <= initial_camera_y + cumulative_y + margin_length:
			GameManager.camera.movespeed = 0
			var size = get_tree().get_nodes_in_group(Group.OnscreenEnemy).size()
			if size <= 0:
				if boss_battle:
					boss_battle = false
					boss_location -= boss_interval
					GameManager.open_inventory()
				if pause_camera:
					pause_camera = false
				GameManager.camera.movespeed = camera_movespeed
	
	# check camera position has not exceeded next block spawn location
	if GameManager.camera.position.y <= initial_camera_y + cumulative_y:
		if cumulative_y < boss_location:
			# add a boss
			var new_level_block = load("res://scenes/boss_blocks/BossBlock1.tscn").instance()
			new_level_block.position = Vector2(0, cumulative_y - new_level_block.length)
			add_child(new_level_block)
			expand_background(new_level_block.length + margin_length)
			boss_battle = true
		else:
			# add a new level block
			var i = rng.randi_range(0, level_block_count - 1)
			var new_level_block = AssetManager.level_blocks[i].instance()
			new_level_block.position = Vector2(0, cumulative_y - new_level_block.length)
			add_child(new_level_block)
			expand_background(new_level_block.length + margin_length)
			if new_level_block.pause_screen:
				pause_camera = true

func expand_background(length):
	# expand tilemap
	cumulative_y -= length
	tilemap.expand(ceil(cumulative_y / tile_size) - 1)
	tilemap.remove_offscreen()
