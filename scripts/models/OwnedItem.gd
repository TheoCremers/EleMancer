extends Reference

class_name OwnedItem

var item_id : int = 1
var slot_id : int = 0
var slot_type : int = 0
var swapped : bool = false

func _init(item_id, slot_id, slot_type):
	self.item_id = item_id
	self.slot_id = slot_id
	self.slot_type = slot_type
