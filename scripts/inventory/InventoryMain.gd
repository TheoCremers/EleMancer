extends Control

var refresh_price = 50
var holding_item = null
var storage_list = []
var type_owned = ["inventory", "equip", "combine"]
var equipped_elements = []

onready var essence_label = $Panel/EssenceLabel

func _ready():
	# add all storage lists here
	storage_list.append(get_node("Panel/Inventory"))
	storage_list.append(get_node("Panel/Equipped"))
	storage_list.append(get_node("Panel/Combine"))
	storage_list.append(get_node("Panel2/Shop"))
	storage_list.append(get_node("Panel2/Sell"))
	# connect buttons
	get_node("Panel2/RefreshButton").connect("pressed", self, "refresh_shop")
	get_node("Panel/CombineButton").connect("pressed", self, "combine_elements")
	get_node("Panel/CloseButton").connect("pressed", self, "close_inventory")
	# show available funds
	update_essence()

func _process(_delta):
	# action pressed (LMB)
	if Input.is_action_just_pressed("shoot"):
		var target_slot = null
		var slot_type
		# check all storage if any has a targetted slot
		for storage in storage_list:
			if storage.target_slot != null:
				target_slot = storage.target_slot
				slot_type = storage.type
		
		if target_slot == null: # no valid slot clicked
			if holding_item != null:
				return_item(holding_item.item_slot)
		else: # if valid slot is clicked
			if holding_item == null: # if you are not holding an item
				if target_slot.item != null: # case where item is picked up
					holding_item = target_slot.item
					target_slot.pick_item()
			else: # you are holding an item
				var old_slot = holding_item.item_slot
				var old_slot_type = holding_item.item_slot.type
				# same slot
				if old_slot == target_slot:
					return_item(old_slot)
				 # inside player inventory
				elif (slot_type in type_owned) and (old_slot_type in type_owned):
					if target_slot.item != null: # swap
						GameManager.swap_item(holding_item.item_slot.slot_id, target_slot.slot_id)
						swap_item(target_slot, old_slot)
					else: # move
						GameManager.move_item(holding_item.item_slot.slot_id, target_slot.slot_id)
						move_item(target_slot, old_slot)
				# inside shop
				elif (slot_type == "shop" and old_slot_type == "shop"):
					if target_slot.item != null: # swap
						swap_item(target_slot, old_slot)
					else: # move
						move_item(target_slot, old_slot)
				# from shop to inventory
				elif (slot_type in type_owned) and old_slot_type == "shop":
					if target_slot.item == null: # buy an item
						var price = Constants.items[holding_item.item_id].buy_price
						if GameManager.buy_item(holding_item.item_id, price, target_slot.slot_id):
							update_essence()
							move_item(target_slot, old_slot)
				# sell an item
				elif slot_type == "sell" and old_slot_type in type_owned:
					var price = Constants.items[holding_item.item_id].buy_price
					price = int(price * 0.5)
					GameManager.sell_item(price, target_slot.slot_id)
					update_essence()
					if target_slot.item == null: 
						move_item(target_slot, old_slot)
					else:
						overwrite_item(target_slot, old_slot)
				
				elif slot_type in type_owned and old_slot_type == "sell":
					if target_slot.item == null: # buy back a sold item
						var price = Constants.items[holding_item.item_id].buy_price
						price = int(price * 0.5)
						if GameManager.buy_item(holding_item.item_id, price, target_slot.slot_id):
							update_essence()
							move_item(target_slot, old_slot)
	
	# move holding_item to mouse position
	if holding_item != null and holding_item.picked:
		holding_item.rect_global_position = get_viewport().get_mouse_position()

func swap_item(target_slot, old_slot):
	var temp_item = target_slot.item
	target_slot.pick_item()
	target_slot.put_item(holding_item)
	old_slot.put_item(temp_item)
	holding_item = null

func move_item(target_slot, old_slot):
	old_slot.clear_reserved()
	target_slot.put_item(holding_item)
	holding_item = null

func return_item(old_slot):
	old_slot.put_item(holding_item)
	holding_item = null

func overwrite_item(target_slot, old_slot):
	target_slot.remove_item()
	move_item(target_slot, old_slot)

func update_essence():
	essence_label.text = str("Essence: \n", GameManager.essence)

func refresh_shop():
	if GameManager.buy_with_essence(refresh_price):
		update_essence()
		for storage in storage_list:
			if storage.type == "shop":
				storage.fill_shop()

func combine_elements():
	for storage in storage_list:
		if storage.type == "combine":
			var combined = storage.try_combine()

func close_inventory():
	# pass the current equiped elements
	for storage in storage_list:
		if storage.type == "equip":
			equipped_elements = storage.get_elements()
	# close inventory, continue game
	GameManager.close_inventory()
