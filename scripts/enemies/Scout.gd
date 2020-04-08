extends "res://scripts/enemies/BaseMovingEnemy.gd"

func _start():
	$AnimatedSprite.playing = true
	._start()
