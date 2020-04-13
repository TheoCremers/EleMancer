extends Node

const number_of_elements = 6

const element_order = ["earth", "shock", "fire", "ice", "life", "death"]

const element_colors = {
	"fire" : Color( 0.8, 0.2, 0, 1 ),
	"ice" : Color( 0.5, 0.6, 1, 1 ),
	"earth" : Color( 0.4, 0.2, 0.2, 1 ),
	"shock" : Color( 0.6, 0.1, 0.8, 1 ),
	"life" : Color( 0.2, 0.9, 0, 1 ),
	"death" : Color( 0.1, 0.1, 0.44, 1 ),
}

const items = {
	0 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/fire/fire1.tres"),
		"level" : 1,
		"type" : "fire",
		"triple" : 10,
		"name" : "lesser fire",
		"buy_price" : 100
	},
	1 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/ice/ice1.tres"),
		"level" : 1,
		"type" : "ice",
		"triple" : 11,
		"name" : "lesser ice",
		"buy_price" : 100
	},
	2 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/earth/earth1.tres"),
		"level" : 1,
		"type" : "earth",
		"triple" : 12,
		"name" : "lesser earth",
		"buy_price" : 100
	},
	3 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/shock/shock1.tres"),
		"level" : 1,
		"type" : "shock",
		"triple" : 13,
		"name" : "lesser shock",
		"buy_price" : 100
	},
	4 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/life/life1.tres"),
		"level" : 1,
		"type" : "life",
		"triple" : 14,
		"name" : "lesser life",
		"buy_price" : 100
	},
	5 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/death/death1.tres"),
		"level" : 1,
		"type" : "lesser death",
		"triple" : 15,
		"name" : "minor death",
		"buy_price" : 100
	},
	10 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/fire/fire2.tres"),
		"level" : 2,
		"type" : "fire",
		"triple" : 20,
		"name" : "refined fire",
		"buy_price" : 200
	},
	11 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/ice/ice2.tres"),
		"level" : 2,
		"type" : "ice",
		"triple" : 21,
		"name" : "refined ice",
		"buy_price" : 200
	},
	12 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/earth/earth2.tres"),
		"level" : 2,
		"type" : "earth",
		"triple" : 22,
		"name" : "refined earth",
		"buy_price" : 200
	},
	13 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/shock/shock2.tres"),
		"level" : 2,
		"type" : "shock",
		"triple" : 23,
		"name" : "refined shock",
		"buy_price" : 200
	},
	14 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/life/life2.tres"),
		"level" : 2,
		"type" : "life",
		"triple" : 24,
		"name" : "refined life",
		"buy_price" : 200
	},
	15 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/death/death2.tres"),
		"level" : 2,
		"type" : "death",
		"triple" : 25,
		"name" : "refined death",
		"buy_price" : 200
	},
	20 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/fire/fire3.tres"),
		"level" : 3,
		"type" : "fire",
		"triple" : -1,
		"name" : "pure fire",
		"buy_price" : 400
	},
	21 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/ice/ice3.tres"),
		"level" : 3,
		"type" : "ice",
		"triple" : -1,
		"name" : "pure ice",
		"buy_price" : 400
	},
	22 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/earth/earth3.tres"),
		"level" : 3,
		"type" : "earth",
		"triple" : -1,
		"name" : "pure earth",
		"buy_price" : 400
	},
	23 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/shock/shock3.tres"),
		"level" : 3,
		"type" : "shock",
		"triple" : -1,
		"name" : "pure shock",
		"buy_price" : 400
	},
	24 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/life/life3.tres"),
		"level" : 3,
		"type" : "life",
		"triple" : -1,
		"name" : "pure life",
		"buy_price" : 400
	},
	25 : {
		"icon" : preload("res://assets/icons/element_icons.sprites/death/death3.tres"),
		"level" : 3,
		"type" : "death",
		"triple" : -1,
		"name" : "pure death",
		"buy_price" : 400
	}
}

const special_combinations = [
	{
		"items" : [0, 2, 4],
		"result" : 5
	}
]
