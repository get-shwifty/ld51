extends Node
class_name World


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_players_devices(devices):
	pass

func pause_game():
	get_tree().paused = true;
	print("paused game")

func resume_game():
	get_tree().paused = false;
	print("resumed game")
