extends Control
class_name MenuBindings

signal return_to_main_menu
signal launch_game

func _on_play_button_pressed():
	launch_game.emit()


func _on_return_button_pressed():
	return_to_main_menu.emit()
