extends StaticBody2D

export(float) var max_health = 100
var damageable = preload("res://scripts/Damageable.gd").new()
onready var sprite = $AnimatedSprite

func _ready():
	add_child(damageable)
	damageable.health = max_health
	damageable.organic = false

func _process(delta):
	if damageable.health <= 0:
		sprite.frame = 5
	elif damageable.health < max_health * 0.25:
		sprite.frame = 4
	elif damageable.health < max_health * 0.5:
		sprite.frame = 3
	elif damageable.health < max_health * 0.75:
		sprite.frame = 2
	elif damageable.health < max_health:
		sprite.frame = 1
	else:
		sprite.frame = 0

func on_death():
	# TODO: dust cloud effect
	# turn off collision
	set_collision_layer_bit(1, false)
