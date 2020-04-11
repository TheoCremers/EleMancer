extends Node2D

var damage_amount:float = 10
var damage_type = "shock"
var jumps_total
var jumps_remaining
var jump_range_sq = 500 * 500
var jump_time = 0.1
var level
var target_body
var target_prev_position
var targets_remaining = []

var LightningEffect = preload("res://scenes/effects/LightningEffect.tscn")
onready var timer = $Timer

func _ready():
	# find all onscreen targets
	targets_remaining = get_tree().get_nodes_in_group(Group.OnscreenEnemy)
	for target in targets_remaining:
		target.damageable.connect("death_signal", self, "_on_target_death")
	# set initial target
	if is_instance_valid(target_body):
		targets_remaining.erase(target_body)
	
	jumps_total = 2 * level
	jumps_remaining = jumps_total
	damage_amount = 10.0 * level
	
	timer.connect("timeout", self, "next_target")
	timer.one_shot = false
	timer.start(jump_time)

func next_target():
	if jumps_remaining <= 0:
		end_effect()
	else:
		var min_sq_distance = jump_range_sq
		var sq_distance = 0
		var new_target = false
		for target in targets_remaining:
			if is_instance_valid(target):
				# find nearest target
				sq_distance = (target.global_position - target_prev_position).length_squared()
				if sq_distance < min_sq_distance:
					min_sq_distance = sq_distance
					new_target = target
		
		if not new_target:
			end_effect()
		else:
			# create lightning sprite between previous and new body
			var new_effect = LightningEffect.instance()
			new_effect.init(target_prev_position - position, new_target.global_position - position)
			add_child(new_effect)
			
			# deal damage to new target
			new_target.damageable.take_damage(damage_amount * (float(jumps_remaining) / float(jumps_total + 1)), damage_type)
			
			# set closest target as new target_body, remove from remaining list
			target_body = new_target
			#target_list.append(target_body)
			target_prev_position = target_body.global_position
			targets_remaining.erase(target_body)
			
			jumps_remaining -= 1

func end_effect():
	timer.disconnect("timeout", self, "next_target")
	yield(timer, "timeout")
	call_deferred('free')

func _on_target_death(damageable):
	targets_remaining.erase(damageable.get_parent())
