extends Node

var OwnedItem = preload("res://scripts/models/OwnedItem.gd")

var player_dead = false
var current_difficulty = 2.5
var owned_items = []
var essence = 5000

# contains often used references such as player and movingcamera
onready var player = $"/root/Game/World/Player"
onready var abilities = $"/root/Game/World/Abilities"
onready var projectiles = $"/root/Game/World/Projectiles"
onready var camera = $"/root/Game/World/MovingCamera"
onready var world = $"/root/Game/World"
onready var inventory = $"/root/Game/UI/Inventory"

func _ready():
	generate_items()
	connect_player()
	open_inventory()

func connect_player():
	player.damageable.connect("death_signal", self, "_on_player_death")

func get_player():
	if not player_dead:
		return player
	else: return false

func _on_player_death(damageable):
	player_dead = true


func generate_items():
	#owned_items.append(OwnedItem.new(10, 0 + 100))
	#owned_items.append(OwnedItem.new(11, 1 + 100))
	owned_items.append(OwnedItem.new(10, 2 + 100))

func move_item(old_slot_id : int, new_slot_id : int):
	for item in owned_items:
		if item.slot_id == old_slot_id:
			item.slot_id = new_slot_id
			return

func remove_item(slot_id : int):
	for item in owned_items:
		if item.slot_id == slot_id:
			owned_items.erase(item)
			return

func swap_item(first_slot_id : int, second_slot_id : int):
	for item in owned_items:
		if item.slot_id == first_slot_id and item.swapped == false:
			item.slot_id = second_slot_id
			item.swapped = true
		if item.slot_id == second_slot_id and item.swapped == false:
			item.slot_id = first_slot_id
			item.swapped = true
	for item in owned_items:
		item.swapped = false

func give_player_item(item_id : int, slot_id : int):
	var item = OwnedItem.new(item_id, slot_id)
	owned_items.append(item)

func buy_item(item_id : int, price : int, slot_id : int) -> bool:
	if essence >= price:
		give_player_item(item_id, slot_id)
		essence -= price
		return true
	else:
		return false

func sell_item(price : int, slot_id : int):
	essence += price
	for item in owned_items:
		if item.slot_id == slot_id:
			owned_items.erase(item)

func buy_with_essence(price : int) -> bool:
	if essence >= price:
		essence -= price
		return true
	else:
		return false

func open_inventory():
	get_tree().paused = true
	inventory.visible = true

func close_inventory():
	inventory.visible = false
	get_tree().paused = false
	player.update_projectile()
