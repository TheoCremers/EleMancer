extends StaticBody2D

var damageable = preload("res://scripts/Damageable.gd").new()

func _ready():
	add_child(damageable)
	damageable.health = 30
	damageable.immune_against.append("normal")

