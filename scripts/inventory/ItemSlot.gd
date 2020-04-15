extends TextureRect

var slot_id
var type
var show_price = false
var half_price = false
var item = null
var reserved = false

func _ready():
	pass

func init(slot_id, type):
	self.slot_id = slot_id
	self.type = type
	name = "item slot %d" % slot_id
	#if slot_id < 24:
	texture = preload("res://assets/inventory/itemslot.png")
	# change slot color based on type
	if type == "equip":
		self_modulate = Color(0.8, 0.8, 1.0)
	elif type == "shop":
		self_modulate = Color(0.8, 1.0, 0.8)
	# price visible?
	if type == "shop" or type == "sell":
		show_price = true
		if type == "sell": half_price = true
		update_price()
	# mouse behaviour
	mouse_filter = Control.MOUSE_FILTER_PASS
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
func clear():
	if (item != null):
		remove_child(item)
		item.queue_free()
		item = null
		update_price()

func set_item(new_item):
	if (item != null):
		remove_child(item)
	add_child(new_item)
	item = new_item
	item.item_slot = self
	update_price()

func pick_item():
	reserved = true
	item.pick_item()
	remove_child(item)
	#$"/root/World/UI/Inventory".add_child(item)
	$"/root/Game/UI/Inventory".add_child(item) # testing purposes
	item = null

func put_item(new_item):
	item = new_item
	item.item_slot = self
	item.put_item()
	item.get_parent().remove_child(item)
	add_child(item)
	reserved = false
	update_price()

func remove_item():
	remove_child(item)
	item.queue_free()
	item = null
	update_price()

func update_price():
	if show_price and item != null:
		$PriceLabel.visible = true
		var price = Constants.items[item.item_id].buy_price
		if half_price: price = int(price * 0.5)
		$PriceLabel.text = str(price)
	else:
		$PriceLabel.visible = false

func clear_reserved():
	reserved = false
	update_price()
