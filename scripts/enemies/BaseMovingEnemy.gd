extends "res://scripts/enemies/BaseEnemy.gd"

export(int, "none", "periodic", "linear") var movement_type = 0
export(float) var movespeed = 200
export(Vector2) var period = Vector2(4.0, 2.0)
export(Vector2) var period_offset = Vector2(0.25, 0)
export(Vector2) var linear_direction = Vector2(0, 1)

var personal_time = 0.0
var motion = Vector2()

func _start():
	linear_direction = linear_direction.normalized()
	._start()

func _physics_process(delta):
	if active:
		if movement_type == 1:
			# circular movement
			motion.x = movespeed * sin((personal_time / period.x + period_offset.x) * 2 * PI)
			motion.y = movespeed * cos((personal_time / period.y + period_offset.y) * 2 * PI)
		elif movement_type == 2:
			# linear movement
			motion = movespeed * linear_direction
		# move the enemy
		motion = move_and_slide(motion)
		personal_time += delta
