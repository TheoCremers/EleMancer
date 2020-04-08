extends "res://scripts/enemies/BaseMovingEnemy.gd"

onready var cast_point = $CastPoint

func _start():
	projectile = load("res://scenes/enemies/projectiles/EnemyProjectile2.tscn")
	._start()

func attack_player():
	var new_projectile = projectile.instance()
	new_projectile.position = cast_point.global_position
	new_projectile.direction = Vector2.UP
	Game_manager.projectiles.add_child(new_projectile)
