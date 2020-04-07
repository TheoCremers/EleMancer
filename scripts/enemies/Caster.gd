extends "res://scripts/enemies/BaseEnemy.gd"

func _start():
	$Sprite.set_material( $Sprite.get_material().duplicate() )
	$AnimationPlayer.play("PreSpawn")
	._start()

func _on_first_enter_screen():
	$Timer.start(2)
	yield($Timer, "timeout")
	$AnimationPlayer.play("Spawn")
	yield($AnimationPlayer, "animation_finished")
	._on_first_enter_screen()
	

func attack_player():
	var direction = (Game_manager.player.global_position - $CastPoint.global_position).normalized()
	var new_projectile = projectile.instance()
	new_projectile.position = $CastPoint.global_position - Game_manager.moving_camera.position
	new_projectile.direction = direction
	Game_manager.moving_camera.add_child(new_projectile)