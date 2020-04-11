extends TextureRect

const slot_size = Vector2(64,64)

var offset
var item_id
var item_name
var item_slot
var picked = false

func _init(item_slot, item_id):
	self.item_slot = item_slot
	self.item_id = item_id
	self.item_name = Constants.element_items[item_id].name
	texture = Constants.element_items[item_id].icon
	# center the item in the slot
	offset = (slot_size - texture.get_size()) * 0.5
	put_item()
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func pick_item():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	picked = true
	
func put_item():
	rect_position = offset
	mouse_filter = Control.MOUSE_FILTER_PASS
	picked = false
