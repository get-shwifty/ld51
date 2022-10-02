extends Control
class_name MenuPause

signal resume_game
signal return_to_main_menu

func _on_resume_button_pressed():
	resume_game.emit()


func _on_main_menu_button_pressed():
	return_to_main_menu.emit()
