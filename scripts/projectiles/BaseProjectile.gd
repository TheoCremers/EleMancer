extends Area2D

var damage_list = []
var max_speed = 600
var direction = Vector2.DOWN
var velocity = Vector2.ZERO
var offset = Vector2.ZERO

func _ready():
	_start()

func _process(delta):
	_update(delta)

func _start():
	position += offset
	rotation = -direction.angle_to(Vector2.UP)
	velocity = direction * max_speed
	connect("body_entered", self, "_on_Area2D_body_entered")

func _update(delta):
	position += velocity * delta

func on_exit_screen():
	call_deferred('free')

func _on_Area2D_body_entered(body):
	# something was hit, check if it can be damaged
	if "damageable" in body:
		body.damageable.take_bulk_damage(damage_list)
	call_deferred('free')