extends Node

const UI_MENU_MAIN : PackedScene = preload("res://ui/menu_main.tscn")
const UI_MENU_PAUSE : PackedScene = preload("res://ui/menu_pause.tscn")
const UI_MENU_BINDINGS : PackedScene = preload("res://ui/menu_bindings.tscn")
#const END_LEVEL_SCENE = preload("res://scenes/ui/LevelEnd.tscn")

const GAME_WORLD : PackedScene = preload("res://world/world.tscn")

var ui_center_slot : CenterContainer = null;
var ui_background : TextureRect = null;
var game_slot : Node = null;

#var ui_main_menu : MenuMain = null;
#var ui_pause_menu : MenuPause = null;
var game_world : World = null;

enum GameState { BOOTING, MENU_MAIN, MENU_BINDINGS, MENU_PAUSE, GAME}
var game_state : GameState = GameState.BOOTING;

# Called when the node enters the scene tree for the first time.
func _ready():
	ui_center_slot = $UICanvas/UICenterContainer
	ui_background = $UICanvas/UIBackground
	game_slot = $GameSlot
	create_game()
	open_main_menu()
	game_state = GameState.MENU_MAIN

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause_game()



func create_game():
	game_world = GAME_WORLD.instantiate();
	game_slot.add_child(game_world);

func quit_application():
	get_tree().quit()

func open_main_menu():
	clear_ui_center_slot()
	var ui_main_menu = UI_MENU_MAIN.instantiate()
	ui_main_menu.launch_solo_game.connect(open_solo_bindings)
	ui_main_menu.launch_multi_game.connect(open_multi_bindings)
	ui_main_menu.quit_game.connect(quit_application)
	ui_center_slot.add_child(ui_main_menu)
	ui_background.visible = true
	game_state = GameState.MENU_MAIN

func open_solo_bindings():
	open_menu_bindings(1)

func open_multi_bindings():
	open_menu_bindings(2)

func open_menu_bindings(nb_of_players):
	if game_state == GameState.MENU_MAIN:
		clear_ui_center_slot()
		var ui_bindings_menu : MenuBindings = UI_MENU_BINDINGS.instantiate()
		ui_bindings_menu.launch_game.connect(launch_game)
		ui_bindings_menu.return_to_main_menu.connect(return_to_main_menu)
		ui_bindings_menu.set_number_of_players(nb_of_players)
		ui_center_slot.add_child(ui_bindings_menu)
		ui_background.visible = true
		game_state = GameState.MENU_BINDINGS
	else:
		push_error("cannot open bindings menu with the current game state")

func pause_game():
	if game_state == GameState.GAME:
		var ui_pause_menu = UI_MENU_PAUSE.instantiate()
		ui_pause_menu.resume_game.connect(resume_game)
		ui_pause_menu.return_to_main_menu.connect(return_to_main_menu)
		ui_center_slot.add_child(ui_pause_menu)
		game_world.pause_game()
		ui_background.visible = true
		game_state = GameState.MENU_PAUSE
	else:
		push_error("cannot pause game in the current game state")

func launch_game(bindings):
	clear_ui_center_slot()
	game_world.set_players_devices(bindings)
	ui_background.visible = false
	game_state = GameState.GAME

func return_to_main_menu():
	if game_state == GameState.MENU_PAUSE or game_state == GameState.MENU_BINDINGS:
		if game_state == GameState.MENU_PAUSE:
			game_world.resume_game()
		open_main_menu()
		game_state = GameState.MENU_MAIN
	else:
		push_error("cannot return to main menu " + game_state)

func resume_game():
	if game_state == GameState.MENU_PAUSE:
		clear_ui_center_slot()
		game_world.resume_game()
		ui_background.visible = false
		game_state = GameState.GAME
	else:
		push_error("cannot resume game because it isn't paused")



func clear_ui_center_slot():
	for child in ui_center_slot.get_children():
		child.queue_free()
