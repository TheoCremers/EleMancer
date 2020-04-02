extends "res://scripts/enemies/BaseEnemy.gd"

onready var animated_sprite = $AnimatedSprite
onready var hitbox = $CollisionShape2D
onready var AOEbox = $"AOE/CollisionShape2D"
var state = 0 # 0 = hidden, 1 = ground ripping, 2 = emerging, 3 = active

func _ready():
	animated_sprite.animation = "Rip"
	animated_sprite.frame = 0
	animated_sprite.playing = false

func _update(delta):
	if state == 3: # active
		._update(delta)

func on_enter_screen():
	if state == 0:
		# disable hitboxes on entering screen
		hitbox.set_deferred("disabled", true)
		AOEbox.set_deferred("disabled", true)
		$Timer.start(1)
	.on_enter_screen()

func _on_Timer_timeout():
	if state == 0:
		animated_sprite.playing = true
		$Timer.start(1)
		state = 1
	elif state == 1:
		animated_sprite.animation = "Emerge"
		animated_sprite.frame = 0
		state = 2

func _on_AnimatedSprite_animation_finished():
	if state == 2:
		animated_sprite.animation = "Idle"
		animated_sprite.frame = 0
		# When fully emerged, enable hitboxes
		hitbox.set_deferred("disabled", false)
		AOEbox.set_deferred("disabled", false)
		state = 3

#func on_death():
#	hitbox.set_deferred("disabled", true)
#	AOEbox.set_deferred("disabled", true)
#	animated_sprite.animation = "Rip"
#	animated_sprite.frame = 4
#	animated_sprite.playing = false