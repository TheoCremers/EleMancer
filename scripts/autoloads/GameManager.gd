extends Node

var player_dead = false
var current_difficulty = 2.5

# contains often used references such as player and movingcamera
onready var player = $"/root/World/Player"
onready var abilities = $"/root/World/Abilities"
onready var projectiles = $"/root/World/Projectiles"
onready var camera = $"/root/World/MovingCamera"

func _ready():
	player.damageable.connect("death_signal", self, "_on_player_death")
	pass

func get_player():
	if not player_dead:
		return player
	else: return false

func _on_player_death(damageable):
	player_dead = true
