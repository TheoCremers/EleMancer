extends Node2D

var skulls = []
var level = 1
var stacks = 0
var stacks_max = 3
var damage_per_tick = 1
var timer_damage
var timer_duration
var default_spacing = Vector2(15, 15)
var default_offset = Vector2(0, -50)
var damageable

func _ready():
	# get reference to skull sprites and hide them
	skulls = get_children()
	for skull in skulls:
		skull.visible = false
	
	#get reference to parent damageable and connect to death event
	damageable = get_parent().damageable
	damageable.connect("death_signal", self, "_on_death")
	
	# make a timer for damage ticks
	timer_damage = Timer.new()
	timer_damage.one_shot = false
	timer_damage.set_wait_time(0.2)
	timer_damage.connect("timeout", self, "_on_damage_timer")
	add_child(timer_damage)
	
	# make a timer for duration of debuff
	timer_duration = Timer.new()
	timer_duration.one_shot = true
	timer_duration.set_wait_time(3)
	timer_duration.connect("timeout", self, "_on_duration_timer")
	add_child(timer_duration)
	
	# set tick damage and max stacks
	damage_per_tick = level * 1
	stacks_max = 2 + level
	if stacks_max > 6: stacks_max = 6
	
	# start with stacks
	add_stacks(1)

func check_level(level):
	if self.level < level:
		self.level = level
		damage_per_tick = level * 1
		stacks_max = 2 + level
		if stacks_max > 6: stacks_max = 6

func add_stacks(amount):
	# start damage timer if previously no stacks
	if stacks == 0:
		timer_damage.start()
	# add stacks up to stacks_max
	if stacks + amount < stacks_max: stacks += amount 
	else: stacks = stacks_max
	# restart duration timer
	timer_duration.start()
	# show skull sprites for amount of stacks
	show_skulls()

func show_skulls():
	var pattern = determine_skull_layers()
	for i in range(0, stacks_max):
		if i + 1 <= stacks:
			skulls[i].position = pattern[i]
			skulls[i].visible = true
		else:
			skulls[i].visible = false

func determine_skull_layers():
	# prepare the offset formation for the projectiles
	var layers
	var pattern = []
	if stacks == 0: return false
	elif stacks == 1: layers = [1]
	elif stacks == 2: layers = [2]
	elif stacks == 3: layers = [1, 2]
	elif stacks == 4: layers = [2, 2]
	elif stacks == 5: layers = [2, 3]
	elif stacks == 6: layers = [3, 3]
	
	for i in range(0, layers.size()):
		for j in range(0, layers[i]):
			var offset_x = (j - (layers[i] - 1) * 0.5) * default_spacing.x
			var offset_y = (i - (layers.size() - 1) * 0.5) * default_spacing.y
			pattern.append(Vector2(offset_x, offset_y) + default_offset)
	return pattern

func _on_damage_timer():
	damageable.take_damage(damage_per_tick * stacks, "death")

func _on_death(damageable):
	# on death while afflicted, spawn a new projectile for extra damage
	if stacks > 0:
		var new_projectile = load("res://scenes/abilities/Reaper.tscn").instance()
		new_projectile.init(level)
		new_projectile.position = global_position
		GameManager.projectiles.call_deferred("add_child", new_projectile)
	# remove this effect
	call_deferred("free")

func _on_duration_timer():
	stacks = 0
	timer_damage.stop()
	show_skulls()




