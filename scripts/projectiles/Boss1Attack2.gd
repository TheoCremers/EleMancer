extends "res://scripts/projectiles/EnemyProjectile.gd"

var secondary = preload("res://scenes/enemies/projectiles/Boss1Attack2Sub.tscn")

func _start():
	piercing = 1000
	$Timer.connect("timeout", self, "spawn_secondary")
	$Timer.set_wait_time(0.4)
	$Timer.start()
	._start()
	spawn_secondary()

func spawn_secondary():
	var new_projectile = secondary.instance()
	new_projectile.position = position
	new_projectile.direction = direction
	GameManager.projectiles.add_child(new_projectile)
