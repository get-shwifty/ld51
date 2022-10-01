extends Node

const UI_MENU_MAIN : PackedScene = preload("res://ui/menu_main.tscn")
const UI_MENU_PAUSE : PackedScene = preload("res://ui/menu_pause.tscn")
#const END_LEVEL_SCENE = preload("res://scenes/ui/LevelEnd.tscn")

const GAME_WORLD : PackedScene = preload("res://world/world.tscn")

var main_scene : Node = null;
var ui_center_slot : CenterContainer = null;
var game_slot : Node = null;

var ui_main_menu : MenuMain = null;
var ui_pause_menu : MenuPause = null;
var game_world = null;


# Called when the node enters the scene tree for the first time.
func _ready():
	main_scene = get_tree().get_current_scene()
	ui_center_slot = main_scene.get_node("UICanvas/UICenterContainer")
	game_slot = main_scene.get_node("GameSlot");
	create_game()
	open_main_menu()

func create_game():
	game_world = GAME_WORLD.instantiate();
	game_slot.add_child(game_world);

func quit_application():
	get_tree().quit()

func open_main_menu():
	clear_ui_center_slot()
	ui_main_menu = UI_MENU_MAIN.instantiate()
	ui_main_menu.launch_solo_game.connect(launch_solo_game)
	ui_main_menu.quit_game.connect(quit_application)
	ui_center_slot.add_child(ui_main_menu)

func pause_game():
	ui_pause_menu = UI_MENU_PAUSE.instantiate()
	ui_pause_menu.resume_game.connect(resume_game)
	ui_pause_menu.return_to_main_menu.connect(open_main_menu)
	ui_center_slot.add_child(ui_pause_menu)
	get_tree().paused = true;

func launch_solo_game():
	clear_ui_center_slot()

func return_to_main_menu():
	open_main_menu()

func resume_game():
	if ui_pause_menu != null:
		clear_ui_center_slot()
	get_tree().paused = false;

func clear_ui_center_slot():
	for child in ui_center_slot.get_children():
		child.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
