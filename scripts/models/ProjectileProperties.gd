extends Reference

var damage_list = []
var speed
var direction
var offset
var abilities = [] # add elemental abilities with their level here

func _init(speed:float, direction:Vector2, offset:Vector2):
	self.speed = speed
	self.direction = direction
	self.offset = offset
	pass
	
func add_element(type, level):
	damage_list.append({"amount" : level * 10, "type" : type})
	abilities.append({"type" : type, "level" : level})