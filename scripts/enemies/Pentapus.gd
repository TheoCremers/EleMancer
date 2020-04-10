extends "res://scripts/enemies/BaseMovingEnemy.gd"

onready var cast_points = [$CastPoint1, $CastPoint2, $CastPoint3, $CastPoint4, $CastPoint5]
export(int) var burst_attack_amount = 3
export(float) var burst_interval = 0.2
var burst_timer

func _start():
	._start()
	# create burst timer
	burst_timer = Timer.new()
	burst_timer.set_wait_time(burst_interval)
	add_child(burst_timer)

func attack_player():
	burst_timer.start()
	for i in range(0, burst_attack_amount):
		yield(burst_timer, "timeout")
		if active:
			var direction = Vector2.RIGHT
			for cast_point in cast_points:
				var new_projectile = projectile.instance()
				new_projectile.position = cast_point.global_position
				new_projectile.direction = direction
				GameManager.projectiles.add_child(new_projectile)
				direction = direction.rotated(0.25 * PI)
	burst_timer.stop()
