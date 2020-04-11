extends Control

var holding_item = null
var storage_list = []

func _ready():
	# add all storage lists here
	storage_list.append(get_node("Panel/Backpack"))
	storage_list.append(get_node("Panel/AttackSlots"))

func _process(_delta):
	# action pressed (LMB)
	if Input.is_action_just_pressed("shoot"):
		var target_slot = null
		# check all storage if any has a targetted slot
		for storage in storage_list:
			if storage.target_slot != null:
				target_slot = storage.target_slot
		
		if target_slot != null: # if valid slot is clicked
			if holding_item == null: # if you are not holding an item
				if target_slot.item != null: # case where item is picked up
					holding_item = target_slot.item
					target_slot.pick_item()
					target_slot.reserved = true
			else: # you are holding an item
				var old_slot = holding_item.item_slot
				if target_slot.item != null: # swap items from old_slot to target_slot
					var temp_item = target_slot.item
					GameManager.swap_item(holding_item.item_slot.slot_id, target_slot.slot_id)
					target_slot.pick_item()
					target_slot.put_item(holding_item)
					holding_item = null
					old_slot.reserved = false
					old_slot.put_item(temp_item)
				else: # move item to new slot
					GameManager.move_item(holding_item.item_slot.slot_id, target_slot.slot_id)
					old_slot.reserved = false
					target_slot.put_item(holding_item)
					holding_item = null
	
	# move holding_item to mouse position
	if holding_item != null and holding_item.picked:
		holding_item.rect_global_position = get_viewport().get_mouse_position()
	
