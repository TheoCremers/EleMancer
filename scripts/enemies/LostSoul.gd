extends "res://scripts/enemies/BaseEnemy.gd"

onready var animated_sprite = $AnimatedSprite
onready var hitbox = $CollisionShape2D
onready var timer = $Timer

func _ready():
	animated_sprite.animation = "Rip"
	animated_sprite.frame = 0
	animated_sprite.playing = false

func _on_first_enter_screen():
	timer.start(1)
	yield(timer, "timeout")
	animated_sprite.playing = true
	timer.start(1)
	yield(timer, "timeout")
	animated_sprite.animation = "Emerge"
	animated_sprite.frame = 0
	yield(animated_sprite, "animation_finished")
	animated_sprite.animation = "Idle"
	animated_sprite.frame = 0
	._on_first_enter_screen()

#func on_death():
#	hitbox.set_deferred("disabled", true)
#	damage_box.set_deferred("disabled", true)
#	animated_sprite.animation = "Rip"
#	animated_sprite.frame = 4
#	animated_sprite.playing = false
