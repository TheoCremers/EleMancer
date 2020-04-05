extends KinematicBody2D

var damageable = preload("res://scripts/Damageable.gd").new()
var projectile1 = preload("res://scenes/enemies/projectiles/BossProjectile1.tscn")
var projectile2 = preload("res://scenes/enemies/projectiles/Boss1Attack2.tscn")
var projectile3 = preload("res://scenes/enemies/projectiles/Boss1Laser.tscn")

onready var hitbox = $CollisionShape2D
onready var AOEbox = $"AOE/CollisionShape2D"
onready var cast_point = $CastPoint.global_position
onready var tween = $Tween

var max_health = 1000

var attack1_cd = 3.0
var attack1_interval = 0.7
var attack1_shots = 3
var attack1_arcs = [40.0, 25.0, 10.0]

var attack2_cd = 5.0

var attack3_spacing = 12.6
var attack3_interval_frames = 3

var attack4_cd = 4.5
var attack4_delay = 0.5

var attack_timer
var attack_timer_sub
var phase = 0
var blue_val = 1.0
var in_phase_transition = true

func _ready():
	add_child(damageable)
	damageable.health = max_health
	# disable hitboxes
	hitbox.set_deferred("disabled", true)
	AOEbox.set_deferred("disabled", true)
	# spawn boss
	spawn_effect()
	# calculate degrees to radians
	for i in range(0, attack1_arcs.size()):
		attack1_arcs[i] = attack1_arcs[i] / 180.0 * PI
	attack3_spacing *= PI / 180.0

func _process(delta):
	pass

func spawn_effect():
	# TODO spawn animation/effect
	tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 3.0, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	# enable hitboxes
	hitbox.set_deferred("disabled", false)
	AOEbox.set_deferred("disabled", false)
	# start in first phase
	in_phase_transition = false
	create_timers()
	enter_next_phase()

func attack1():
	if not Game_manager.player_dead:
		# shoot 3 fans of decreasing arc towards player
		for arc in attack1_arcs:
			# TODO: gun_glow?
			attack_timer_sub.start()
			yield(attack_timer_sub, "timeout")
			if in_phase_transition: break
			fan_attack(attack1_shots, arc)

func attack2():
	if not Game_manager.player_dead:
		# shoot an attack that splits off into multiple projectiles
		var new_projectile = projectile2.instance()
		new_projectile.position = cast_point
		new_projectile.direction = Vector2.DOWN
		Game_manager.projectiles.add_child(new_projectile)

func attack3():
	if not Game_manager.player_dead:
		var direction = Vector2.UP
		while not in_phase_transition:
			# skip desired number of frames
			for j in range(0, attack3_interval_frames):
				yield(get_tree(),"idle_frame")
			var new_projectile = projectile1.instance()
			new_projectile.position = cast_point
			direction = direction.rotated(attack3_spacing)
			new_projectile.direction = direction
			new_projectile.max_speed = 250
			Game_manager.projectiles.add_child(new_projectile)

func attack4():
	if not Game_manager.player_dead:
		var new_projectile = projectile3.instance()
		new_projectile.position = cast_point
		Game_manager.projectiles.add_child(new_projectile)

func fan_attack(shots:int, arc:float):
	# get player direction from cast point
	var direction = (Game_manager.get_player().global_position - cast_point).normalized()
	# converts arc from degrees to radians
	var arc_segment = arc / float(shots - 1)
	# create shots that form a fan within a defined arc
	for i in range(0, shots):
		var new_projectile = projectile1.instance()
		new_projectile.position = cast_point
		new_projectile.direction = direction.rotated(arc * 0.5 - arc_segment * i)
		Game_manager.projectiles.add_child(new_projectile)

func create_timers():
	# prepare main attack timer
	attack_timer = Timer.new()
	attack_timer.one_shot = false
	add_child(attack_timer)
	# prepare sub attack timer
	attack_timer_sub = Timer.new()
	attack_timer_sub.one_shot = true
	add_child(attack_timer_sub)

func enter_next_phase():
	if phase == 0:
		attack_timer.set_wait_time(attack1_cd)
		attack_timer.connect("timeout", self, "attack1")
		attack_timer.start()
		attack_timer_sub.set_wait_time(attack1_interval)
		attack1()
	elif phase == 1:
		attack_timer.set_wait_time(attack2_cd)
		attack_timer.disconnect("timeout", self, "attack1")
		attack_timer.connect("timeout", self, "attack2")
		attack_timer.start()
		attack2()
	elif phase == 2:
		attack_timer.disconnect("timeout", self, "attack2")
		attack3()
	elif phase == 3:
		attack_timer.set_wait_time(attack4_cd)
		attack_timer.connect("timeout", self, "attack4")
		attack_timer.start()
		attack4()
	# set current phase
	phase += 1

func phase_transition():
	in_phase_transition = true
	# disable hitboxes
	hitbox.set_deferred("disabled", true)
	AOEbox.set_deferred("disabled", true)
	# stop attack timer
	attack_timer.stop()
	# regain health
	damageable.health = max_health
	# flash green
	tween.interpolate_property(self, "modulate:b", blue_val, blue_val - 0.33, 3.0, Tween.TRANS_SINE, Tween.EASE_IN)
	blue_val -= 0.33
	tween.start()
	yield(tween, "tween_completed")
	# enable hitboxes
	hitbox.set_deferred("disabled", false)
	AOEbox.set_deferred("disabled", false)
	in_phase_transition = false
	enter_next_phase()

func on_death():
	if phase < 4: # 4 is the final phase
		phase_transition()
	else:
		# make a more elaborate death animation
		call_deferred("free")