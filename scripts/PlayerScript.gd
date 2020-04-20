extends KinematicBody2D

var movespeed = 400
var motion = Vector2()
var crushed = false

var attack_cd_time = 0.5
var rng = RandomNumberGenerator.new()

var damageable = preload("res://scripts/Damageable.gd").new()
var projectile = preload("res://scenes/PlayerProjectile.tscn")
var projectile_constructor = preload("res://scripts/projectiles/ConstructProjectile.gd").new()

onready var attack_timer = $"AttackTimer"
onready var debug_info = $"/root/Game/UI/DebugInfo"
onready var attack_sfx = $AudioStreamPlayer

func _ready():
	add_child(damageable)
	damageable.health = 100
	crushed = false
	
	attack_timer.set_wait_time(attack_cd_time)
	

func _physics_process(delta):
	# movement
	var axis = get_directional_input()
	motion = axis * movespeed
	motion = move_and_slide(motion)
	
	# shooting
	var shoot = Input.is_action_pressed("shoot")
	if shoot and attack_timer.is_stopped():
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
		GameManager.projectiles.add_child(new_projectile)
		attack_timer.start()
	# make a sound
	attack_sfx.set_pitch_scale(rng.randf_range(0.8, 1.2))
	attack_sfx.play()


func _on_inner_body_entered(body):
	# triggers when player inner body overlaps with obstacle (signal from InnerBody node)
	crushed = true

func update_projectile():
	projectile_constructor.elements = GameManager.inventory.equipped_elements
	projectile_constructor.construct()


func debug_report():
	# show position, speed and delta
	debug_info.text = str("FPS: ", Performance.get_monitor(Performance.TIME_FPS))
	debug_info.text = debug_info.text + str("\nX: ", position.x, "\nY: ", position.y)
	debug_info.text = debug_info.text + str("\nVX: ", motion.x, "\nVY: ", motion.y)
	debug_info.text = debug_info.text + str("\ncrushed: ", crushed)
	debug_info.text = debug_info.text + str("\n#enemies: ", get_tree().get_nodes_in_group(Group.OnscreenEnemy).size())
	
