extends "res://scripts/enemies/BaseEnemy.gd"

func attack_player():
	var direction = (Game_manager.player.global_position - $CastPoint.global_position).normalized()
	var new_projectile = projectile.instance()
	new_projectile.position = $CastPoint.global_position - Game_manager.moving_camera.position
	new_projectile.direction = direction
	Game_manager.moving_camera.add_child(new_projectile)