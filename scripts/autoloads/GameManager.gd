extends Node

var OwnedItem = preload("res://scripts/models/OwnedItem.gd")

var in_menu = true
var player_dead = false
var current_difficulty = 2.5
var owned_items = []
var essence = 300

# contains often used references such as player and movingcamera
onready var player = $"/root/World/Player"
onready var abilities = $"/root/World/Abilities"
onready var projectiles = $"/root/World/Projectiles"
onready var camera = $"/root/World/MovingCamera"

func _ready():
	generate_items()
	if not in_menu:
		connect_player()

func connect_player():
	player.damageable.connect("death_signal", self, "_on_player_death")

func get_player():
	if not player_dead:
		return player
	else: return false

func _on_player_death(damageable):
	player_dead = true


func generate_items():
	for i in range(0,6):
		var new_item = OwnedItem.new(i, i)
		owned_items.append(new_item)

func move_item(oldslot : int, newslot : int):
	for item in owned_items:
		if item.slot_id == oldslot:
			item.slot_id = newslot
			return

func remove_item(slot : int):
	for item in owned_items:
		if item.slot_id == slot:
			owned_items.erase(item)
			return

func swap_item(first_slot : int, second_slot : int):
	for item in owned_items:
		if item.slot_id == first_slot and item.swapped == false:
			item.slot_id = second_slot
			item.swapped = true
		if item.slot_id == second_slot and item.swapped == false:
			item.slot_id = first_slot
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
