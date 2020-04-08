extends "res://scripts/enemies/BaseEnemy.gd"

var accuracy = 10.0 / 180.0 * PI
var rng = RandomNumberGenerator.new()

func _start():
	$Sprite.set_material( $Sprite.get_material().duplicate() )
	$AnimationPlayer.play("PreSpawn")
	# start randomizer
	rng.randomize()
	._start()

func _on_first_enter_screen():
	$Timer.start(2)
	yield($Timer, "timeout")
	$AnimationPlayer.play("Spawn")
	yield($AnimationPlayer, "animation_finished")
	._on_first_enter_screen()

func on_death():
	set_collision_state(false)
	$AnimationPlayer.play_backwards("Spawn")
	active = false
	yield($AnimationPlayer, "animation_finished")
	call_deferred("free")
	return true

func attack_player():
	var direction = (Game_manager.player.global_position - $CastPoint.global_position).normalized()
	direction = direction.rotated(rng.randf_range(-accuracy, accuracy))
	var new_projectile = projectile.instance()
	new_projectile.position = $CastPoint.global_position - Game_manager.moving_camera.position
	new_projectile.direction = direction
	Game_manager.moving_camera.add_child(new_projectile)
