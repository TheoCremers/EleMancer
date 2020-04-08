extends Node2D

signal death_signal(damageable)

onready var UI = $"/root/World/UI"

const damage_number = preload("res://scenes/effects/DamageNumber.tscn")

var health
var organic = true
var show_bar = false
var weak_against = []
var strong_against = []
var immune_against = []
var invulnerable = false

func calculate_damage(amount, type):
	if invulnerable: return 0
	else:
		var damage = amount
		if type in weak_against:
			damage *= 2
		if type in strong_against:
			damage *= 0.5
		if type in immune_against:
			damage = 0
		return damage

func show_damage(amount):
	# show damage taken with damage_number instance
	var new_damage_number = damage_number.instance()
	new_damage_number.amount = amount
	new_damage_number.rect_position = get_global_transform_with_canvas().origin
	UI.add_child(new_damage_number)

func take_damage(amount, type):
	var damage_taken = calculate_damage(amount, type)
	health -= damage_taken
	if damage_taken > 0:
		show_damage(damage_taken)
	
	if health <= 0:
		on_death()
		return false
	else: return true

func take_bulk_damage(damage_list):
	var damage_sum = 0
	for damage in damage_list:
		damage_sum += calculate_damage(damage.amount, damage.type)
	health -= damage_sum
	if damage_sum > 0:
		show_damage(damage_sum)
	
	if health <= 0:
		on_death()
		return false
	else: return true

func on_death():
	# emit death signal for AOE to remove this body from their lists
	if get_parent().has_method("on_death"):
		var dead = get_parent().on_death()
		if dead:
			emit_signal("death_signal", self)
	else:
		yield(get_tree(), "idle_frame")
		get_parent().call_deferred('free')
		emit_signal("death_signal", self)
