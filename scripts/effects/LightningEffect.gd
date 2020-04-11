extends Sprite

func init(pos1:Vector2, pos2:Vector2):
	# set position, rotation and scale of the sprite
	position = (pos1 + pos2) * 0.5
	rotation = (pos2 - pos1).angle()
	var distance = (pos2 - pos1).length()
	scale.x = distance / 64.0
	
	var timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.set_wait_time(0.5)
	timer.autostart = true
	add_child(timer)

func _on_timer_timeout():
	call_deferred('free')
