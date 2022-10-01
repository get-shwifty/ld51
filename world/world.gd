extends Node
class_name World

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
