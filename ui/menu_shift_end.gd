extends Control
class_name MenuShiftEnd

signal resume_game
signal return_to_main_menu

func set_final_score(score):
	$PanelContainer/VBoxContainer/ScoreLabel.set_text("Your score is "+str(score));


func _on_main_menu_button_pressed():
	return_to_main_menu.emit()
