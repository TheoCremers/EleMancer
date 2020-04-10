extends Node2D

export(int) var block_id = 0
export(bool) var can_mirror = false
export(bool) var pause_screen = false
export(float) var base_difficulty = 5.0
export(float) var length = 255

var number_of_children = 0

func _ready():
	number_of_children = get_child_count()
	# connect to tree exit function of all children
	for child in get_children():
		child.connect("tree_exited", self, "_on_child_exited")

func _on_child_exited():
	number_of_children -= 1
	if number_of_children <= 0:
		call_deferred("free")
