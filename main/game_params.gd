extends Node

const GAME_DURATION = 4*60

var bindings = [
	{
		"name" : "WASD/ZQSD",
		"id" : DevicesHelper.KEYBOARD_ZQSD,
		"description" : "Move: WASD\\ZQSD\nSelection : WASD\\ZQSD\nInteract: Tab"
	},
	{
		"name" : "Arrow keys",
		"id" : DevicesHelper.KEYBOARD_ARROWS,
		"description" : "Move: Arrow Keys\nSelection : Arrow Keys\nInteract: Enter"
	},
	{
		"name" : "Controller 1",
		"id" : DevicesHelper.CONTROLLER1,
		"description" : "Move : Left Stick\nSelection: BXY\nInteract: A"
	},
	{
		"name" : "Controller 2",
		"id" : DevicesHelper.CONTROLLER2,
		"description" : "Move : Left Stick\nSelection: BXY\nInteract: A"
	},
]


signal difficulty_changed

var difficulties = [
	{
		"name" : "First time behind the counter",
		"id" : "easy",
		"menu" : preload("res://data/menu/menu.tres")
	},
	{
		"name" : "Java lover",
		"id" : "medium",
		"menu" : preload("res://data/menu/menu_medium.tres")
	},
	{
		"name" : "Brewing chef",
		"id" : "hard",
		"menu" : preload("res://data/menu/menu_full.tres")
	},
]
var current_difficulty_index = 0;

func get_current_difficulty():
	return difficulties[current_difficulty_index]
	
func get_current_menu():
	return get_current_difficulty()["menu"]

func increment_difficulty():
	current_difficulty_index += 1
	if current_difficulty_index >= difficulties.size():
		current_difficulty_index = 0
	difficulty_changed.emit()

func decrement_difficulty():
	current_difficulty_index -= 1
	if current_difficulty_index < 0:
		current_difficulty_index = difficulties.size() - 1
	difficulty_changed.emit()
