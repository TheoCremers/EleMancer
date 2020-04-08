extends "res://scripts/AOE.gd"

var following = true
onready var timer = $Timer
onready var AOEbox = $CollisionShape2D
onready var target_line = $Targeting
onready var beam_line = $Beam

func _ready(): # called after AOE ready
	AOEbox.set_deferred("disabled", true)
	# setup timer
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start()
	
func _process(delta):
	# track player with line until timer expires
	if not Game_manager.player_dead:
		if following:
			var to_player = Game_manager.player.global_position - global_position
			rotation = to_player.angle()
			target_line.points[1] = Vector2.RIGHT * to_player.length()

func _on_timer_timeout():
	# stop following and start beam
	following = false
	timer.set_wait_time(0.4)
	timer.disconnect("timeout", self, "_on_timer_timeout")
	timer.start()
	yield(timer, "timeout")
	target_line.visible = false
	beam_line.visible = true
	AOEbox.set_deferred("disabled", false)
	# continue to disable beam
	timer.set_wait_time(1.5)
	timer.start()
	yield(timer, "timeout")
	call_deferred("free")
