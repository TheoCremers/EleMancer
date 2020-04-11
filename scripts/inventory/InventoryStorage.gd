extends GridContainer

const ItemClass = preload("res://scripts/inventory/Item.gd");
const ItemSlotClass = preload("res://scenes/inventory/ItemSlot.tscn")
#const slot_texture = preload("res://assets/images/slot.png");

onready var memberpanel = $"/root/World/UI/PartyMemberPanel/Panel/Equipment";

export(int, "inventory", "equip", "combine", "shop") var type = 0
export(int, 0, 30, 1) var number_of_slots = 10
var target_slot = null

func _ready():
	for i in range(number_of_slots):
		var slot = ItemSlotClass.instance();
		var index = i + type * 100
		slot.init(index)
		slot.visible = true
		add_child(slot)
		slot.connect("mouse_entered", self, "_mouse_enter_slot", [slot])
		slot.connect("mouse_exited", self, "_mouse_exit_slot", [slot])
	update_inventory()

func update_inventory():
	# clear any slot of current items
	for slot in get_children():
		slot.clear()
	# check owned items
	for item in GameManager.owned_items:
		var new_item = ItemClass.new(null, item.item_id)
		# put owned items into appropriate slots
		for slot in get_children():
			if slot.slot_id == item.slot_id and slot.reserved == false:
				slot.set_item(new_item)

func get_free_slot():
	for slot in get_children():
		if slot.item == null and slot.reserved == false:
			return slot.slot_id
	return -1

func _mouse_enter_slot(slot):
	target_slot = slot

func _mouse_exit_slot(slot):
	if target_slot == slot:
		target_slot = null

#func _input(event):
#	# Show tooltip
#	if event is InputEventMouseButton and event.pressed:
#		var target_slot = _get_target_slot()
#		if target_slot != null and target_slot.item != null:
#			if holding_item == null:
#				selected_slot = target_slot.slot_id
#				_update_tooltip(target_slot.item.itemId)
#
#	# Drag
#	if holding_item != null && holding_item.picked:
#		holding_item.rect_global_position = Vector2(event.position.x, event.position.y);
#
#	# Drop
#	if event is InputEventMouseButton and not event.pressed and holding_item != null:
#		var target_slot = _get_target_slot()
#		if target_slot != null:
#			var old_slot = holding_item.item_slot;
#			if target_slot.item != null:
#				var temp_item = target_slot.item;
#				# From equip -> inv:
#				if old_slot.slot_id >= 24:
#					if not Constants.ITEM_DB[target_slot.item.itemId].slot == Constants.ITEM_DB[holding_item.itemId].slot:
#						_drop_on_hero_panel();
#						return
#				GameManager.swap_item(holding_item.item_slot.slot_id, target_slot.slot_id)
#				selected_slot = target_slot.slot_id
#				target_slot.pick_item();
#				target_slot.put_item(holding_item);
#				holding_item = null;
#				old_slot.reserved = false
#				old_slot.put_item(temp_item);
#			else:
#				GameManager.move_item(holding_item.item_slot.slot_id, target_slot.slot_id)
#				selected_slot = target_slot.slot_id
#				old_slot.reserved = false
#				target_slot.put_item(holding_item);
#				holding_item = null;
#	return
