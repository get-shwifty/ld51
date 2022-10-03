extends Node
class_name World

const START_FIRST_CLIENT = 3000
const SPAWN_INTERVAL = 10000

var character_scene: PackedScene = preload("res://world/character.tscn")

@onready var tables : Node2D = $Tables
@onready var last_clients_spawn = Time.get_ticks_msec() - SPAWN_INTERVAL + START_FIRST_CLIENT
@onready var hud : HUD = $HUD;

var is_game_started = true;
var score = 0
var combo = 0
var time_passed = 0

func _ready():
	for t in $Tables.get_children():
		t.bad_coffee_served.connect(bad_coffee_served)
		t.coffee_served.connect(coffee_served)

func bad_coffee_served():
	combo = 0
	refresh_HUD()

func coffee_served(name):
	combo += 1
	score += 10 * combo
	refresh_HUD()

func refresh_HUD():
	hud.set_combo(combo)
	hud.set_score(score)
	hud.set_time_progression(time_passed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_game_started:
		return
	
	time_passed += delta;
	refresh_HUD();
	
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
	var characters = find_children("Character?")
	for character in characters:
		remove_child(character)

	for i in range(devices.size()):
		var character = character_scene.instantiate()
		character.set_device_mode(devices[i])
		character.player_num = str(i)
		character.global_position = find_child("CharacterPos" + str(i)).global_position
		add_child(character)

func start_game():
	is_game_started = true;

func stop_game():
	is_game_started = false;

func pause_game():
	get_tree().paused = true;
	print("paused game")

func resume_game():
	get_tree().paused = false;
	print("resumed game")
