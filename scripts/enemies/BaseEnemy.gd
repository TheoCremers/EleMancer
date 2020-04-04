extends KinematicBody2D

var projectile = preload("res://scenes/enemies/projectiles/EnemyProjectile1.tscn")

var damageable = preload("res://scripts/Damageable.gd").new()

export(float) var health = 100
export(bool) var can_attack = false
export(float) var attack_cd = 1.5
var attack_timer
var offscreen = true
var offscreen_free_time = 3.0
var offscreen_timer

func _ready():
	_start()

func _start():
	add_child(damageable)
	damageable.health = health
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
	add_to_group(Group.OnscreenEnemy)
	offscreen = false
	offscreen_timer.stop()
	if can_attack:
		attack_timer.start()

func on_exit_screen():
	remove_from_group(Group.OnscreenEnemy)
	offscreen = true
	offscreen_timer.start()

func _on_attack_timer():
	if not offscreen and not Game_manager.player_dead:
		attack_player()
		
func _on_offscreen_too_long():
	call_deferred("free")