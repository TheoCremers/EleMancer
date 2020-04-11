extends Node

const element_order = ["earth", "shock", "fire", "ice", "life", "death"]

const element_colors = {
	"fire" : Color( 0.8, 0.2, 0, 1 ),
	"ice" : Color( 0.5, 0.6, 1, 1 ),
	"earth" : Color( 0.4, 0.2, 0.2, 1 ),
	"shock" : Color( 0.6, 0.1, 0.8, 1 ),
	"life" : Color( 0.2, 0.9, 0, 1 ),
	"death" : Color( 0.1, 0.1, 0.44, 1 ),
}

const element_items = {
	0 : {
		"icon" : preload("res://assets/icons/ele_icons1.sprites/fire1.tres"),
		"level" : 1,
		"type" : "fire",
		"name" : "minor fire"
	},
	1 : {
		"icon" : preload("res://assets/icons/ele_icons1.sprites/ice1.tres"),
		"level" : 1,
		"type" : "ice",
		"name" : "minor ice"
	},
	2 : {
		"icon" : preload("res://assets/icons/ele_icons1.sprites/earth1.tres"),
		"level" : 1,
		"type" : "earth",
		"name" : "minor earth"
	},
	3 : {
		"icon" : preload("res://assets/icons/ele_icons1.sprites/shock1.tres"),
		"level" : 1,
		"type" : "shock",
		"name" : "minor shock"
	},
	4 : {
		"icon" : preload("res://assets/icons/ele_icons1.sprites/life1.tres"),
		"level" : 1,
		"type" : "life",
		"name" : "minor life"
	},
	5 : {
		"icon" : preload("res://assets/icons/ele_icons1.sprites/death1.tres"),
		"level" : 1,
		"type" : "death",
		"name" : "minor death"
	}
}
