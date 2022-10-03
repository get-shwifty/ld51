extends Control
class_name MenuBindings

const BINDING_SELECTION = preload("res://ui/binding_selection.tscn")

signal return_to_main_menu
signal launch_game(bindings)

var players_nb = 1
var selection_widgets = []

func set_number_of_players(nb):
	players_nb = nb
	for child in $PanelContainer/VBoxContainer/HBoxContainer/HBoxContainer.get_children():
		child.queue_free()
	selection_widgets.clear()
	for i  in range(0, players_nb):
		var current_widget = BINDING_SELECTION.instantiate()
		current_widget.set_player_index(i +1)
		current_widget.set_bindings_list(GameParams.bindings)
		current_widget.current_binding_index = i
		current_widget.refresh_bindings_display()
		$PanelContainer/VBoxContainer/HBoxContainer/HBoxContainer.add_child(current_widget)
		selection_widgets.push_back(current_widget)

func _ready():
	refresh_difficulty_display();

func _on_play_button_pressed():
	var res = selection_widgets.map(func(x): return x.get_current_binding_id())
	launch_game.emit(res)


func _on_return_button_pressed():
	return_to_main_menu.emit()


func refresh_difficulty_display():
	$PanelContainer/VBoxContainer/HBoxContainerDifficulty/LabelDifficultyName.set_text(GameParams.get_current_difficulty()["name"]);

func _on_button_left_pressed():
	GameParams.decrement_difficulty()
	refresh_difficulty_display()


func _on_button_right_pressed():
	GameParams.increment_difficulty()
	refresh_difficulty_display()

