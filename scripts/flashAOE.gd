extends Area2D

export(float) var damage_amount = 10
export(String) var damage_type = "fire"
export(int) var level = 1

func _ready():
	# determine radius  en damage based on effect level
	$AnimatedSprite.scale = Vector2(1, 1) * 0.5 * level
	$AnimatedSprite.playing = true
	$CollisionShape2D.shape.radius = 50 * level
	damage_amount = level * 10
	# slightly delayed damage
	var timer = Timer.new()
	timer.connect("timeout", self, "deal_damage")
	timer.one_shot = true
	add_child(timer)
	timer.start(0.1)

func deal_damage():
	for body in get_overlapping_bodies():
		if "damageable" in body:
			body.damageable.take_damage(damage_amount, damage_type)

func _on_AnimatedSprite_animation_finished():
	call_deferred('free')
