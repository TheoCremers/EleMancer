extends "res://scripts/projectiles/BaseProjectile.gd"

signal stop_orbiting(projectile)

var FireExplosion = preload("res://scenes/abilities/FireExplosion.tscn")
var ChainLightning = preload("res://scenes/abilities/ChainLightning.tscn")
var DeathGrasp = preload("res://scenes/abilities/DeathGrasp.tscn")

var abilities
var orbiting = false
var homing = false
var homing_target
var homing_timer
var homing_accel = 100
var rotate = false
var rotate_speed
var animated_sprite

func init(properties):
	self.damage_list = properties.damage_list
	self.max_speed = properties.speed
	self.direction = properties.direction
	self.offset = properties.offset
	self.abilities = properties.abilities

func _start():
	# add projectile property abilities
	for ability in abilities:
		if ability.type == "ice":
			piercing = ability.level
		elif ability.type == "life":
			add_homing_area(ability.level)
	
	if abilities[0].type == "earth":
		rotate = true
		rotate_speed = rand_range(0, 0.05 * PI)
		rotation = rand_range(0, 2 * PI)
	
	set_graphics()
	
	._start()

func _update(delta):
	if rotate:
		rotation += rotate_speed
	if homing:
		# use acceleration instead of straight up direction
		accel_target_direction()
	else:
		if velocity.length() < max_speed:
			velocity = (velocity + velocity.normalized() * homing_accel).clamped(max_speed)
	if not orbiting:
		._update(delta)

func set_graphics():
	animated_sprite = $AnimatedSprite
	# Make shader unique
	animated_sprite.set_material( animated_sprite.get_material().duplicate() )
	# change sprite to match primary element
	animated_sprite.animation = abilities[0].type
	# add outline shaders for secondary and tertiary elements
	var color1
	var color2
	if abilities.size() > 1:
		color1 =  Constants.element_colors[abilities[1].type]
	else:
		color1 = Color(0, 0, 0, 0)
	if abilities.size() > 2:
		color2 = Constants.element_colors[abilities[2].type]
	else:
		color2 = color1
	animated_sprite.material.set_shader_param("color1", color1)
	animated_sprite.material.set_shader_param("color2", color2)
	# change size of projectile based on level
	scale = Vector2.ONE *(1 + abilities[0].level * 0.1)

func add_homing_area(level):
	var homing_area = load("res://scenes/abilities/HomingArea.tscn").instance()
	homing_area.get_node("CollisionShape2D").shape.radius = level * 60
	homing_area.connect("body_entered", self, "set_homing_target")
	add_child(homing_area)
	$"HomingArea/CollisionShape2D".disabled = true
	# add a timer to enable homing area after delay
	homing_timer = Timer.new()
	homing_timer.set_one_shot(true)
	homing_timer.connect("timeout", self, "enable_homing_area")
	add_child(homing_timer)
	homing_timer.start(0.2)

func set_homing_target(body):
	# handle multiple bodies entering in single frame
	if not homing:
		body.damageable.connect("death_signal", self, "lose_homing_target")
		homing_target = body
		homing = true
		# disable homing area for now
		$"HomingArea/CollisionShape2D".set_deferred("disabled", true)
		#$"HomingArea".disconnect("body_entered", self, "set_homing_target")
		# stop orbiting
		if orbiting:
			orbiting = false
			emit_signal("stop_orbiting", self)
			velocity = direction * max_speed
#	else:
#		# only set new target if it is closer
#		if (global_position - body.global_position).length_squared() < \
#		   (global_position - homing_target.global_postion).length_squared():
#			homing_target.damageable.disconnect("death_signal", self, "lose_homing_target")
#			body.damageable.connect("death_signal", self, "lose_homing_target")
#			homing_target = body
	

func accel_target_direction():
	if is_instance_valid(homing_target):
		var acceleration = (homing_target.global_position - global_position).normalized() * homing_accel
		velocity = (velocity + acceleration).clamped(max_speed)
		if abilities[0].type != "earth":
			rotation = -velocity.angle_to(Vector2.UP)

func add_fire_explosion(level):
	var new_object = FireExplosion.instance()
	new_object.position = global_position
	new_object.level = level
	Game_manager.abilities.call_deferred("add_child", new_object)

func add_chain_lightning(level, body):
	var new_object = ChainLightning.instance()
	#new_object.position = global_position
	new_object.level = level
	new_object.target_body = body
	Game_manager.abilities.call_deferred("add_child", new_object)

func add_death_grasp(level, body):
	# check if it can be affected by curse
	if body.damageable.organic:
		# check if already has deathgrasp object
		if body.has_node("DeathGrasp"):
			var death_grasp = body.get_node("DeathGrasp")
			death_grasp.check_level(level)
			death_grasp.add_stacks(1)
		else:
			var new_object = DeathGrasp.instance()
			new_object.level = level
			body.call_deferred("add_child", new_object)

func on_exit_screen():
	if not orbiting:
		.on_exit_screen()

func _on_Area2D_body_entered(body):
	# something was hit, check if it can be damaged
	if "damageable" in body:
		var alive = body.damageable.take_bulk_damage(damage_list)
		
		# add on spawn abilities
		for ability in abilities:
			if ability.type == "fire":
				add_fire_explosion(ability.level)
			elif ability.type == "shock":
				add_chain_lightning(ability.level, body)
			elif ability.type == "death":
				add_death_grasp(ability.level, body)
		
		if piercing <= 0:
			remove_projectile()
		else:
			if homing:
				lose_homing_target()
			piercing -= 1
	else:
		# hit non-destroyable object (which cannot be pierced)
		remove_projectile()

func remove_projectile():
	if orbiting:
		emit_signal("stop_orbiting", self)
	call_deferred('free')

func lose_homing_target(damageable = null):
	homing = false
	homing_target = null
	homing_timer.start()
	
func enable_homing_area():
	$"HomingArea/CollisionShape2D".set_deferred("disabled", false)
	#$"HomingArea".connect("body_entered", self, "set_homing_target")
