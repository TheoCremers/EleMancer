extends "res://scripts/projectiles/BaseProjectile.gd"

export(float) var damage_amount
export(String) var damage_type
export(float) var projectile_speed

func _start():
	damage_list.append({"amount" : damage_amount, "type": damage_type})
	max_speed = projectile_speed
	._start()
	