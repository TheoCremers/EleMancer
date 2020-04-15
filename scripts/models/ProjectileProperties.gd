extends Reference

var damage_list = []
var speed
var direction
var offset
var abilities = [] # add elemental abilities with their level here
var direct_dmg_types = ["life", "shock", "earth", "ice"]

func _init(speed:float, direction:Vector2, offset:Vector2):
	self.speed = speed
	self.direction = direction
	self.offset = offset
	pass
	
func add_element(type, level):
	var dmg_multiplier = 0
	if type in direct_dmg_types:
		dmg_multiplier = 10
	damage_list.append({"amount" : level * dmg_multiplier, "type" : type})
	abilities.append({"type" : type, "level" : level})
