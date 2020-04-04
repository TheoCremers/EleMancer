extends Reference

const ProjectileProperties = preload("res://scripts/Models/ProjectileProperties.gd")
const OrbitingSystem = preload("res://scenes/abilities/OrbitingSystem.tscn")

var elements = [{"type" : "fire", "level" : 2},
				{"type" : "life", "level" : 1}]

var max_level = 0
var primary_element
var projectiles = []
var projectile_properties = []
var projectile_pattern = []
var default_offset = Vector2.UP * 50
var default_spacing = Vector2(20, 50)

func construct():
	elements.sort_custom(self, "sort_elements")
	determine_primary_element()
	reset_projectiles()
	determine_projectiles(primary_element)
	determine_projectile_pattern()
	coat_projectiles(primary_element)
	prepare_properties(primary_element)
	
	if is_nonprimary_earth():
		reset_projectiles(false)
		determine_projectiles("earth")
		determine_projectile_pattern()
		coat_projectiles("earth")
		prepare_properties("earth", false)
	
func reset_projectiles(full:bool = true):
	projectiles.clear()
	projectile_pattern.clear()
	if full:
		projectile_properties.clear()
		# TODO also remove orbiting systems

func sort_elements(element1, element2):
	if element1.level != element2.level:
		return element1.level > element2.level
	else:
		var index1 = Constants.element_order.find(element1.type)
		var index2 = Constants.element_order.find(element2.type)
		return index1 <= index2

func determine_primary_element():
	# assumes a sorted list of elements with level > type (max 3 elements)
	max_level = elements[0].level
	primary_element = elements[0].type
	if elements.size() > 2:
		if elements[1].level == max_level and elements[2].type == elements[1].type:
			primary_element = elements[1].type

func determine_projectiles(projectile_element):
	for element in elements:
		if element.type == projectile_element:
			projectiles.append(element.duplicate())

func determine_projectile_pattern():
	# prepare the offset formation for the projectiles
	var layers = [0, 0 ,0]
	var current_level = max_level + 1
	var n_layers = 0
	for projectile in projectiles:
		if projectile.level < current_level:
			current_level = projectile.level
			n_layers += 1
		layers[n_layers - 1] += 1
	for i in range(0, n_layers):
		for j in range(0, layers[i]):
			var offset_x = (j - (layers[i] - 1) * 0.5) * default_spacing.x
			var offset_y = (i - (n_layers - 1) * 0.5) * default_spacing.y
			projectile_pattern.append(Vector2(offset_x, offset_y))

func coat_projectiles(projectile_element):
	# apply secondary and tertiarty elements if appropriate
	for element in elements:
		if element.type != projectile_element:
			for projectile in projectiles:
				if projectile.has("secondary"):
					if projectile.secondary.type == element.type:
						projectile.secondary.level += element.level
					else:
						projectile["tertiary"] = element.duplicate()
				else:
					projectile["secondary"] = element.duplicate()
	# check that no coating exceeds projectile level
	for projectile in projectiles:
		if projectile.has("secondary"):
			if projectile.secondary.level > projectile.level:
				projectile.secondary.level = projectile.level
			if projectile.has("tertiary"):
				if projectile.tertiary.level > projectile.level:
					projectile.tertiary.level = projectile.level

func prepare_properties(projectile_element, primary:bool = true):
	for i in range(0, projectiles.size()):
		var speed = 600
		var direction = Vector2.UP
		var offset = default_offset + projectile_pattern[i]
		
		# make new properties instance
		var new_properties = ProjectileProperties.new(speed, direction, offset)
		
		# Add damage types and abilities
		new_properties.add_element(projectiles[i].type, projectiles[i].level)
		if projectiles[i].has("secondary"):
			new_properties.add_element(projectiles[i].secondary.type, projectiles[i].secondary.level)
			if projectiles[i].has("tertiary"):
				new_properties.add_element(projectiles[i].tertiary.type, projectiles[i].tertiary.level)
		
		# add properties to projectile properties array
		if primary:
			projectile_properties.append(new_properties)
		
		# if earth element is primary, add an orbiting system to player
		if projectile_element == "earth":
			var new_orbiting_system = OrbitingSystem.instance()
			new_orbiting_system.init(new_properties, projectiles[i].level)
			Game_manager.get_player().add_child(new_orbiting_system)

func is_nonprimary_earth():
	if primary_element == "earth":
		return false
	for element in elements:
		if element.type == "earth":
			return true