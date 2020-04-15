extends GridContainer

const ItemClass = preload("res://scripts/inventory/Item.gd");
const ItemSlotClass = preload("res://scenes/inventory/ItemSlot.tscn")

export(String, "inventory", "equip", "shop", "sell", "combine") var type = "inventory"
export(int, 0, 30, 1) var number_of_slots = 10
var target_slot = null
var rng

func _ready():
	for i in range(number_of_slots):
		var slot = ItemSlotClass.instance();
		var index = i
		if type == "equip": index += 100
		elif type == "shop": index += 200
		elif type == "sell": index += 300
		elif type == "combine": index += 400
		slot.init(index, type)
		slot.visible = true
		add_child(slot)
		slot.connect("mouse_entered", self, "_mouse_enter_slot", [slot])
		slot.connect("mouse_exited", self, "_mouse_exit_slot", [slot])
	# set items
	if type == "shop":
		rng = RandomNumberGenerator.new()
		rng.randomize()
		fill_shop()
	elif type == "inventory" or type == "equip" or type == "combine":
		update_inventory()

func update_inventory():
	# clear any slot of current items
	for slot in get_children():
		slot.clear()
	# check owned items
	for item in GameManager.owned_items:
		# put owned items into appropriate slots
		for slot in get_children():
			if slot.slot_id == item.slot_id and slot.reserved == false:
				var new_item = ItemClass.new(item.item_id)
				slot.set_item(new_item)

func get_free_slot():
	for slot in get_children():
		if slot.item == null and slot.reserved == false:
			return slot.slot_id
	return -1

func fill_shop():
	# new random level 1 elements
	for slot in get_children():
		slot.clear()
		var new_item = ItemClass.new(rng.randi() % Constants.number_of_elements)
		slot.set_item(new_item)

func try_combine() -> bool:
	# try to triple
	var slots = get_children()
	if slots[0].item != null and slots[1].item != null and slots[2].item != null:
		var first_item = Constants.items[slots[0].item.item_id]
		# can it be tripled?
		if first_item.triple >= 0:
			# all three items the same?
			if slots[0].item.item_id == slots[1].item.item_id and \
			slots[0].item.item_id == slots[2].item.item_id:
				combine(first_item.triple)
				return true
	# get all item ids in combine slots
	var item_ids = []
	for slot in slots:
		if slot.item != null:
			item_ids.append(slot.item.item_id)
	item_ids.sort()
	# check all sorted combos for a match
	for combo in Constants.special_combinations:
		var combo_item_ids = combo.items
		combo_item_ids.sort()
		if item_ids == combo_item_ids:
			combine(combo.result)
			return true
	# no valid combination found
	return false

func combine(result_id):
	# remove old items
	for slot in get_children():
		GameManager.remove_item(slot.slot_id)
		slot.clear()
	# create new item
	var result_slot = get_child(1)
	GameManager.give_player_item(result_id, result_slot.slot_id)
	var new_item = ItemClass.new(result_id)
	result_slot.set_item(new_item)

func _mouse_enter_slot(slot):
	target_slot = slot

func _mouse_exit_slot(slot):
	if target_slot == slot:
		target_slot = null

func get_elements():
	var elements = []
	for slot in get_children():
		if slot.item != null:
			var item = Constants.items[slot.item.item_id]
			elements.append({"type" : item.type, "level" : item.level})
	return elements
