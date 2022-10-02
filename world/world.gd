extends Node
class_name World

const SPAWN_INTERVAL = 10000

@onready var tables : Node2D = $Tables
@onready var time = Time.new()
@onready var last_clients_spawn = time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time.get_ticks_msec() - last_clients_spawn > SPAWN_INTERVAL:
		var indexes = []
		for i in range(tables.get_child_count()):
			if tables.get_child(i).current_clients == null:
				indexes.push_back(i)

func set_players_devices(devices):
	pass

func pause_game():
	get_tree().paused = true;
	print("paused game")

func resume_game():
	get_tree().paused = false;
	print("resumed game")
