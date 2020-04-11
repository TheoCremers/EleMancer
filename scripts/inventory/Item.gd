extends TextureRect

const slot_size = Vector2(64,64)

var offset
var item_id
var item_name
var item_slot
var picked = false

func _init(item_id):
	self.item_id = item_id
	self.item_name = Constants.items[item_id].name
	texture = Constants.items[item_id].icon
	# center the item in the slot
	offset = (slot_size - texture.get_size()) * 0.5
	put_item()
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func pick_item():
	picked = true
	
func put_item():
	rect_position = offset
	picked = false
