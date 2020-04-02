extends Sprite

func init(pos1:Vector2, pos2:Vector2):
	# set position, rotation and scale of the sprite
	position = (pos1 + pos2) * 0.5
	rotation = (pos2 - pos1).angle()
	var distance = (pos2 - pos1).length()
	scale.x = distance / 64.0
	
	var timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.start(0.5)

func _on_timer_timeout():
	call_deferred('free')