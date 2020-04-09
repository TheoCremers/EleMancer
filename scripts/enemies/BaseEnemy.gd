extends KinematicBody2D

var projectile = preload("res://scenes/enemies/projectiles/EnemyProjectile1.tscn")

var damageable = preload("res://scripts/Damageable.gd").new()

export(float) var health = 100
export(float) var damage_touch = 10
export(bool) var can_attack = false
export(float) var attack_cd = 1.5
var attack_timer
var offscreen = true
var offscreen_free_time = 3.0
var offscreen_timer
var active = false
var first = true
var damage_box

func _ready():
	_create_damage_box()
	_start()

func _create_damage_box():
	damage_box = Area2D.new()
	damage_box.set_collision_layer(0) # nothing collides with this
	damage_box.set_collision_mask(0) # start with no damage
	damage_box.set_script(load("res://scripts/AOE.gd"))
	damage_box.damage_touch = damage_touch
	var damage_collision = CollisionShape2D.new()
	# use the same shape and position + rotation as collision shape
	damage_collision.shape = $CollisionShape2D.shape 
	damage_collision.position = $CollisionShape2D.position
	damage_collision.rotation = $CollisionShape2D.rotation
	add_child(damage_box)
	damage_box.add_child(damage_collision)

func _start():
	set_collision_state(false)
	add_child(damageable)
	damageable.health = health
	damageable.invulnerable = true
	# make ofscreen timer
	offscreen_timer = Timer.new()
	offscreen_timer.set_wait_time(offscreen_free_time)
	offscreen_timer.one_shot = true
	offscreen_timer.connect("timeout", self, "_on_offscreen_too_long")
	add_child(offscreen_timer)
	# make attack timer
	if can_attack:
		attack_timer = Timer.new()
		attack_timer.set_wait_time(attack_cd)
		attack_timer.one_shot = false
		attack_timer.connect("timeout", self, "_on_attack_timer")
		add_child(attack_timer)
		attack_timer.start()

func _process(delta):
	_update(delta)

func _update(delta):
	pass
	
func attack_player():
	var direction = (Game_manager.player.global_position - global_position).normalized()
	var new_projectile = projectile.instance()
	new_projectile.position = position - Game_manager.moving_camera.position
	new_projectile.direction = direction
	Game_manager.moving_camera.add_child(new_projectile)

func on_enter_screen():
	if first:
		_on_first_enter_screen()
	else:
		offscreen_timer.stop()
	first = false
	add_to_group(Group.OnscreenEnemy)
	offscreen = false
	if can_attack:
		attack_timer.start()

func _on_first_enter_screen():
	active = true
	damageable.invulnerable = false
	set_collision_state(true)


func on_exit_screen():
	remove_from_group(Group.OnscreenEnemy)
	offscreen = true
	if damageable.health > 0:
		offscreen_timer.start()
		if can_attack:
			attack_timer.stop()

func _on_attack_timer():
	if active and not Game_manager.player_dead:
		attack_player()
		
func _on_offscreen_too_long():
	call_deferred("free")

func set_collision_state(state):
	set_collision_layer_bit(3, state) # projectile collision
	damage_box.set_collision_mask_bit(0, state) # player touch damage
