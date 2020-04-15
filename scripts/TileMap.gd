extends TileMap

export(int) var width = 14
export(int) var height = 16
var bottom_cell = height - 2
var top_cell = -1
const tile_size = 64

func expand(new_top : int):
	var amount = top_cell - new_top
	for i in range(0, width):
		for j in range(0, amount):
			set_cell(i - 1, top_cell - 1 - j, 1)
	top_cell = new_top

func remove_offscreen():
	var new_bottom = GameManager.camera.get_bottom_y_pos()
	new_bottom = floor(new_bottom / tile_size) + 1
	if new_bottom < bottom_cell:
		var amount = bottom_cell - new_bottom
		for i in range(0, width):
			for j in range(0, amount):
				set_cell(i - 1, bottom_cell - j, -1)
		bottom_cell = new_bottom
