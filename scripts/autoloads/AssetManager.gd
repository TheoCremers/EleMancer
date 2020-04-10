extends Node

var level_blocks = []

func _ready():
	var path = "res://scenes/level_blocks"
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var block_name = dir.get_next()
		if block_name == "":
			break # end of level blocks
		elif !block_name.begins_with(".") and !block_name.ends_with(".import"):
			level_blocks.append(load(path + "/" + block_name))
	dir.list_dir_end()
