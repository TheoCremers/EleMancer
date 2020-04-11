extends GridContainer

const ItemClass = preload("res://scripts/inventory/Item.gd");
const ItemSlotClass = preload("res://scenes/inventory/ItemSlot.tscn")

onready var memberpanel = $"/root/World/UI/PartyMemberPanel/Panel/Equipment";

export(String, "inventory", "equip", "shop", "sell") var type = "inventory"
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
	elif type == "inventory" or type == "equip":
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

func _mouse_enter_slot(slot):
	target_slot = slot

func _mouse_exit_slot(slot):
	if target_slot == slot:
		target_slot = null
