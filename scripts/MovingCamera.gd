extends Camera2D

export(float) var movespeed = 0
var border_width = 20

onready var border_bottom = $BorderBottom/CollisionShape2D
onready var border_top = $BorderTop/CollisionShape2D
onready var border_left = $BorderLeft/CollisionShape2D
onready var border_right = $BorderRight/CollisionShape2D
onready var screen = $Screen/CollisionShape2D

func _ready():
	var viewport_size = get_viewport().size
	screen.shape.set_extents(viewport_size * 0.5)
	border_bottom.shape.set_extents(Vector2(viewport_size.x * 0.5, border_width))
	border_bottom.get_parent().position = Vector2(0, viewport_size.y * 0.5)
	border_top.shape.set_extents(Vector2(viewport_size.x * 0.5, border_width))
	border_top.get_parent().position = Vector2(0, -viewport_size.y * 0.5)
	border_left.shape.set_extents(Vector2(border_width, viewport_size.y * 0.5))
	border_left.get_parent().position = Vector2(-viewport_size.x * 0.5, 0)
	border_right.shape.set_extents(Vector2(border_width, viewport_size.y * 0.5))
	border_right.get_parent().position = Vector2(viewport_size.x * 0.5, 0)
	

func _process(delta):
	if not Game_manager.player_dead:
		# move player and camera
		Game_manager.player.move_and_slide(Vector2.UP * movespeed)
		position.y -= movespeed * delta


func _on_Screen_area_exited(area):
	if area.has_method("on_exit_screen"):
		area.on_exit_screen()


func _on_Screen_body_entered(body):
	if body.has_method("on_enter_screen"):
		body.on_enter_screen()


func _on_Screen_body_exited(body):
	if body.has_method("on_exit_screen"):
		body.on_exit_screen()

