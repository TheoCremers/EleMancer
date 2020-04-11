extends TextureRect

var slot_id
var item = null
var reserved = false

func _ready():
	pass

func init(slot_id):
	self.slot_id = slot_id
	name = "item slot %d" % slot_id
	#if slot_id < 24:
	texture = preload("res://assets/inventory/itemslot.png")
	# mouse behaviour
	mouse_filter = Control.MOUSE_FILTER_PASS
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
func clear():
	if (item != null):
		remove_child(item)
		item.queue_free()
		item = null

func set_item(new_item):
	if (item != null):
		remove_child(item)
	add_child(new_item)
	item = new_item
	item.item_slot = self

func pick_item():
	item.pick_item()
	remove_child(item)
	#$"/root/World/UI/Inventory".add_child(item);
	$"/root/Inventory".add_child(item);
	item = null

func put_item(new_item):
	item = new_item
	item.item_slot = self
	item.put_item()
	item.get_parent().remove_child(item)
	add_child(item)
