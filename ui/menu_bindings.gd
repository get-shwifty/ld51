extends Control
class_name MenuBindings

const BINDING_SELECTION = preload("res://ui/binding_selection.tscn")

signal return_to_main_menu
signal launch_game(bindings)

var bindings = [
	{
		"name" : "WASD/ZQSD",
		"id" : DevicesHelper.KEYBOARD_ZQSD,
		"description" : "blabla"
	},
	{
		"name" : "Arrow keys",
		"id" : DevicesHelper.KEYBOARD_ARROWS,
		"description" : "blibli"
	},
	{
		"name" : "Controller 1",
		"id" : DevicesHelper.CONTROLLER1,
		"description" : "blublu"
	},
	{
		"name" : "Controller 2",
		"id" : DevicesHelper.CONTROLLER2,
		"description" : "blublu"
	},
]


var players_nb = 1
var selection_widgets = []

func set_number_of_players(nb):
	players_nb = nb
	for child in $HBoxContainer.get_children():
		child.queue_free()
	selection_widgets.clear()
	for i  in range(0, players_nb):
		var current_widget = BINDING_SELECTION.instantiate()
		current_widget.set_bindings_list(bindings)
		$HBoxContainer.add_child(current_widget)
		selection_widgets.push_back(current_widget)
		

func _on_play_button_pressed():
	var res = selection_widgets.map(func(x): return x.get_current_binding_id())
	launch_game.emit(res)


func _on_return_button_pressed():
	return_to_main_menu.emit()


