extends Node2D

var projectile_type = preload("res://scenes/PlayerProjectile.tscn")
var projectile_property
var radius
var phase_spacing
var phase_start
var period
var max_projectiles
var spawn_time
var projectiles = []
var personal_time = 0.0
var spawn_timer

func init(projectile_property, level):
	self.projectile_property = projectile_property
	#self.projectile_property.offset = Vector2.ZERO
	self.radius = 100 - projectile_property.offset.y
	self.phase_start = projectile_property.offset.x * 2 / self.radius
	self.max_projectiles = level * 2
	self.period = 4 * PI * radius / projectile_property.speed
	self.spawn_time = 1.0 / sqrt(level)
	self.phase_spacing = 2 * PI / float(max_projectiles)
	
	# make an array that can contain all orbiting projectiles
	for i in range(0, max_projectiles):
		self.projectiles.append(false)

func _ready():
	# start a spawn timer
	spawn_timer = Timer.new()
	spawn_timer.connect("timeout", self, "_on_spawn")
	spawn_timer.one_shot = true
	add_child(spawn_timer)
	spawn_timer.start(spawn_time)

func _process(delta):
	if not Game_manager.player_dead:
		var phase_offset = phase_start
		var direction = Vector2.ZERO
		for projectile in projectiles:
			if projectile:
				direction.x = sin(2 * PI * (personal_time / period) + phase_offset)
				direction.y = cos(2 * PI * (personal_time / period) + phase_offset)
				projectile.direction = direction
				#projectile.rotation = -direction.angle_to(Vector2.UP)
				projectile.position = Game_manager.player.position + radius * Vector2(- direction.y, direction.x)
			phase_offset += phase_spacing
	
	personal_time += delta

func create(i):
	var new_projectile = projectile_type.instance()
	new_projectile.init(projectile_property)
	new_projectile.orbiting = true
	new_projectile.connect("stop_orbiting", self, "_on_projectile_left") # to remove reference in projectiles array
	Game_manager.projectiles.add_child(new_projectile)
	projectiles[i] = new_projectile

func _on_spawn():
	var n = 0
	for projectile in projectiles:
		n += 1
		if not projectile:
			create(n - 1)
			break # only spawn one projectile at a time
	# check if more projectiles have to be made
	if n < max_projectiles:
		spawn_timer.start()

func _on_projectile_left(projectile):
	projectiles[projectiles.find(projectile)] = false
	if spawn_timer.is_stopped():
		spawn_timer.start()
