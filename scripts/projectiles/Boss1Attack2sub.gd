extends "res://scripts/projectiles/EnemyProjectile.gd"

var secondary = preload("res://scenes/enemies/projectiles/BossProjectile1.tscn")

func _start():
	piercing = 1000
	$Timer.connect("timeout", self, "spawn_secondary")
	$Timer.set_wait_time(0.8)
	$Timer.start()
	._start()
	$Tween.interpolate_property(self, "velocity", Vector2.ZERO, direction * max_speed, 3.0, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()

func spawn_secondary():
	var new_projectile = secondary.instance()
	new_projectile.position = position
	new_projectile.direction = direction.rotated(0.5 * PI)
	Game_manager.projectiles.add_child(new_projectile)
	new_projectile = secondary.instance()
	new_projectile.position = position
	new_projectile.direction = direction.rotated(-0.5 * PI)
	Game_manager.projectiles.add_child(new_projectile)