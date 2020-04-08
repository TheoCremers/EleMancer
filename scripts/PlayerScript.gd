extends KinematicBody2D

var movespeed = 400
var motion = Vector2()
var crushed = false

var attack_cd_time = 0.5

var damageable = preload("res://scripts/Damageable.gd").new()
var projectile = preload("res://scenes/PlayerProjectile.tscn")
var projectile_constructor = preload("res://scripts/projectiles/ConstructProjectile.gd").new()

onready var debug_info = $"/root/World/UI/DebugInfo"

func _ready():
	add_child(damageable)
	damageable.health = 100
	crushed = false
	
	$AttackTimer.set_wait_time(attack_cd_time)
	
	projectile_constructor.construct()

func _physics_process(delta):
	# movement
	var axis = get_directional_input()
	motion = axis * movespeed
	motion = move_and_slide(motion)
	
	# shooting
	var shoot = Input.is_action_pressed("shoot")
	if shoot and $AttackTimer.is_stopped():
		basic_attack()
	
	debug_report()

func get_directional_input():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis.normalized()

func basic_attack():
	for projectile_property in projectile_constructor.projectile_properties:
		var new_projectile = projectile.instance()
		new_projectile.init(projectile_property)
		new_projectile.position = global_position
		Game_manager.projectiles.add_child(new_projectile)
		$AttackTimer.start()


func _on_inner_body_entered(body):
	# triggers when player inner body overlaps with obstacle (signal from InnerBody node)
	crushed = true


func debug_report():
	# show position, speed and delta
	debug_info.text = str("X: ", position.x, "\nY: ", position.y)
	debug_info.text = debug_info.text + str("\nVX: ", motion.x, "\nVY: ", motion.y)
	debug_info.text = debug_info.text + str("\ncrushed: ", crushed)
