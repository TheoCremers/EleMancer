extends "res://scripts/projectiles/BaseProjectile.gd"

export(float) var damage_amount
export(String) var damage_type

func _start():
	damage_list.append({"amount" : damage_amount, "type": damage_type})
	._start()
	