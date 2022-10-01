extends Control 
class_name MenuMain

signal launch_solo_game
signal quit_game

func _on_solo_button_pressed():
	launch_solo_game.emit()

func _on_multi_button_pressed():
	launch_solo_game.emit()

func _on_quit_button_pressed():
	quit_game.emit()
