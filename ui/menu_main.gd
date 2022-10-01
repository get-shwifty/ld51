extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_solo_button_pressed():
	Main.launch_solo_game();

func _on_multi_button_pressed():
	Main.launch_solo_game();

func _on_quit_button_pressed():
	Main.quit_game();
