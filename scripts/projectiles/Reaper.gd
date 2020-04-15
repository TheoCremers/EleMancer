extends "res://scripts/projectiles/BaseProjectile.gd"

var level
var homing_target = false
var homing_accel = 100

func init(level):
	self.level = level
	self.damage_list = [{"type" : "death", "amount" : level * 20}]
	self.max_speed = 400
	self.direction = Vector2.UP

func _start():
	# change sprite to match primary element and size to match level
	scale = Vector2.ONE *(1 + level * 0.1)
	._start()
	yield(get_tree().create_timer(.1), "timeout") # wait a bit
	set_nearest_target()

func _update(delta):
	if homing_target:
		# use acceleration instead of straight up direction
		accel_target_direction()
		# flip sprites if direction changed
		$Sprite.flip_h = velocity.x < 0
		$Sprite2.flip_h = velocity.x < 0
	else:
		if velocity.length() > 10:
			velocity = velocity*0.8
	._update(delta)

func set_nearest_target():
	var targets = get_tree().get_nodes_in_group(Group.OnscreenEnemy)
	var min_sq_distance = 100000000
	var sq_distance = 0
	homing_target = false
	for target in targets:
		# check if target is alive
		if target.damageable.health > 0:
			# find nearest target
			sq_distance = (target.global_position - global_position).length_squared()
			if sq_distance < min_sq_distance:
				min_sq_distance = sq_distance
				homing_target = target
		
	if homing_target:
		homing_target.damageable.connect("death_signal", self, "lose_homing_target")
	else:
		fade_out()

func accel_target_direction():
	if is_instance_valid(homing_target): # TODO make this more efficient
		var acceleration = (homing_target.global_position - global_position).normalized() * homing_accel
		velocity = (velocity + acceleration).clamped(max_speed)
	else:
		lose_homing_target(null)

func _on_Area2D_body_entered(body):
	# something was hit, check if it can be damaged
	if "damageable" in body:
		homing_target = false
		var alive = body.damageable.take_bulk_damage(damage_list)
		if alive:
			fade_out()
		else:
			yield(get_tree(), "idle_frame")
			set_nearest_target()

func lose_homing_target(damageable):
	homing_target = false
	yield(get_tree().create_timer(.1), "timeout") # wait a bit
	set_nearest_target()

func fade_out():
	$CollisionShape2D.call_deferred("disabled", true)
	var tween = $Tween
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	call_deferred("free")
