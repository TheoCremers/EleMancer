extends Area2D

export(float) var damage_touch = 10
export(float) var damage_interval = 0.5 # upon entering take damage every 'interval' seconds
export(String) var damage_type = ""
var damageables_overlapping = []
var prev_hurt_time = []
var personal_time = 0.0

func _ready():
	connect("body_entered", self, "_on_AOE_body_entered")
	connect("body_exited", self, "_on_AOE_body_exited")

func _process(delta):
	var n_bodies = damageables_overlapping.size()
	for i in range(n_bodies - 1, -1, -1): # inverted to make sure removed elements do not effect loop
		if prev_hurt_time[i] <= personal_time:
			prev_hurt_time[i] = personal_time + damage_interval
			damageables_overlapping[i].take_damage(damage_touch, damage_type)
	personal_time += delta


func _on_AOE_body_entered(body):
	if "damageable" in body:
		body.damageable.connect("death_signal", self, "_remove_damageable")
		damageables_overlapping.append(body.damageable)
		prev_hurt_time.append(0.0)


func _on_AOE_body_exited(body):
	if "damageable" in body:
		_remove_damageable(body.damageable)


func _remove_damageable(damageable):
	var i = damageables_overlapping.find(damageable)
	if not i < 0:
		damageables_overlapping.remove(i)
		prev_hurt_time.remove(i)