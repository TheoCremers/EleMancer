extends TileMap

export(int) var width = 14
export(int) var height = 16

var top_cell = height
var bottom_cell = height

var biome_freq = 0.02

var grads = []
var noise_scale = Vector2(0.1, 0.1)
var noise_amp = 2.0
var grad_offset = ceil(height * noise_scale.y)
var grad_covered = grad_offset

#var grads2 = []
#var noise2_scale = Vector2(0.4, 0.4)
#var noise2_amp = 0.0
#var grad2_offset = ceil(height * noise2_scale.y)
#var grad2_covered = grad2_offset

var rng = RandomNumberGenerator.new()

const tile_size = 64

func _ready():
	rng.randomize()
	# add one row of gradients at the lowest position to get started
	add_gradient_row(1)
	#add_gradient_row(2)
	# fill screen with tiles up to screen top
	expand(-1)

func expand(new_top : int):
	# ensure gradients are available for perlin noise
	add_required_gradients(new_top)
	# add required amount of tiles
	var amount = top_cell - new_top
	var cell_id = 1
	for i in range(0, width):
		for j in range(0, amount):
			# add some variants in the grass
			if rng.randi() % 20 == 0:
				cell_id = rng.randi() % 4 + 4
			else:
				cell_id = 1
			set_cell(i - 1, top_cell - 1 - j, cell_id)
	
	var st = Vector2.ZERO
	var st2 = Vector2.ZERO
	var noise_val = 0
	var local_j = 0
	var biome_bias
	# set alternative tiles (sand/green grass)
	for j in range(0, amount - 1):
		# get the local j coordinate in the tilemap grid
		local_j = top_cell - 1 - j
		# set biome bias that emphasizes one tile type over another
		biome_bias = 0.5 * sin(local_j * biome_freq * PI)
		for i in range(0, width - 1):
			st = Vector2(i * noise_scale.x, local_j * noise_scale.y)
			#st2 = Vector2(i * noise2_scale.x, local_j * noise2_scale.y)
			noise_val = perlin_noise(st) * noise_amp #+ perlin_noise2(st2) * noise2_amp
			if noise_val < -0.5 + biome_bias:
				set_cell_quadrant(i, local_j, 2)
			elif noise_val > 0.5 + biome_bias:
				set_cell_quadrant(i, local_j, 3)
	# move the currently set top tile cell
	top_cell = new_top

func remove_offscreen():
	var new_bottom = GameManager.camera.get_bottom_y_pos()
	new_bottom = floor(new_bottom / tile_size) + 1
	# remove unnecessary gradients
	remove_old_gradients(new_bottom)
	# remove tiles that are offscreen
	if new_bottom < bottom_cell:
		var amount = bottom_cell - new_bottom
		for i in range(0, width):
			for j in range(0, amount):
				set_cell(i - 1, bottom_cell - j, -1)
		bottom_cell = new_bottom

func set_cell_quadrant(x, y, tile_id):
	# set four cells to tile_id around coordinates x and y
	set_cell(x - 1, y, tile_id)
	set_cell(x, y, tile_id)
	set_cell(x - 1, y - 1, tile_id)
	set_cell(x, y - 1, tile_id)
	update_bitmask_area(Vector2(x - 1, y))
	update_bitmask_area(Vector2(x - 1, y - 1))
	update_bitmask_area(Vector2(x, y))
	update_bitmask_area(Vector2(x, y - 1))

func get_gradient(st : Vector2) -> Vector2:
	return grads[grad_offset - st.y][st.x]

#func get_gradient2(st : Vector2) -> Vector2:
#	return grads2[grad2_offset - st.y][st.x]

func perlin_noise(st : Vector2):
	var i = st.floor()
	var f = st - i
	var ux = f.x * f.x * (3.0 - 2.0 * f.x)
	var uy = f.y * f.y * (3.0 - 2.0 * f.y)
	return lerp(lerp(get_gradient(i + Vector2(0.0, 0.0)).dot(f - Vector2(0.0, 0.0)),
		   get_gradient(i + Vector2(1.0, 0.0)).dot(f - Vector2(1.0, 0.0)), ux),
		   lerp(get_gradient(i + Vector2(0.0, 1.0)).dot(f - Vector2(0.0, 1.0)),
		   get_gradient(i + Vector2(1.0, 1.0)).dot(f - Vector2(1.0, 1.0)), ux), uy)

#func perlin_noise2(st : Vector2):
#	var i = st.floor()
#	var f = st - i
#	var ux = f.x * f.x * (3.0 - 2.0 * f.x)
#	var uy = f.y * f.y * (3.0 - 2.0 * f.y)
#	return lerp(lerp(get_gradient2(i + Vector2(0.0, 0.0)).dot(f - Vector2(0.0, 0.0)),
#		   get_gradient2(i + Vector2(1.0, 0.0)).dot(f - Vector2(1.0, 0.0)), ux),
#		   lerp(get_gradient2(i + Vector2(0.0, 1.0)).dot(f - Vector2(0.0, 1.0)),
#		   get_gradient2(i + Vector2(1.0, 1.0)).dot(f - Vector2(1.0, 1.0)), ux), uy)

func add_required_gradients(y_min : int):
	var min_grad = floor(y_min * noise_scale.y)
	while min_grad < grad_covered:
		add_gradient_row(1)
		grad_covered -= 1
	# second gradients
#	min_grad = floor(y_min * noise2_scale.y)
#	while min_grad < grad2_covered:
#		add_gradient_row(2)
#		grad2_covered -= 1

func remove_old_gradients(y_max : int):
	var max_grad = ceil(y_max * noise_scale.y)
	while max_grad < grad_offset:
		grads.pop_front()
		grad_offset -= 1
#	max_grad = ceil(y_max * noise2_scale.y)
#	while max_grad < grad2_offset:
#		grads2.pop_front()
#		grad2_offset -= 1

func add_gradient_row(gradient_id : int):
	var new_grads = []
	if gradient_id == 1:
		for i in range(0, ceil(width * noise_scale.x) + 1):
			new_grads.append(random_gradient())
		grads.append(new_grads)
#	elif gradient_id == 2:
#		for i in range(0, ceil(width * noise2_scale.x) + 1):
#			new_grads.append(random_gradient())
#		grads2.append(new_grads)

func random_gradient() -> Vector2:
	var phi = rng.randf() * 2.0 * PI
	return Vector2(sin(phi), cos(phi))
