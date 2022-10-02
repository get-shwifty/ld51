extends Node
class_name World

const START_FIRST_CLIENT = 3000
const SPAWN_INTERVAL = 10000

@onready var tables : Node2D = $Tables
@onready var last_clients_spawn = Time.get_ticks_msec() - SPAWN_INTERVAL + START_FIRST_CLIENT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var now = Time.get_ticks_msec()
	if Time.get_ticks_msec() - last_clients_spawn > SPAWN_INTERVAL:
		last_clients_spawn = now

		var indexes = []
		for i in range(tables.get_child_count()):
			if tables.get_child(i).is_empty():
				indexes.push_back(i)
		if len(indexes) > 0:
			var table_index = indexes[randi() % len(indexes)]
			var table = tables.get_child(table_index)
			var nb_clients_max = len(table.chairs)
			var nb_clients = randi_range(1, nb_clients_max)
			table.create_clients(nb_clients)

func set_players_devices(devices):
	pass

func pause_game():
	get_tree().paused = true;
	print("paused game")

func resume_game():
	get_tree().paused = false;
	print("resumed game")
