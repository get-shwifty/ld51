extends Node

const RES_UI_MENU_MAIN = "res://ui/menu_main.tscn"
const RES_UI_MENU_PAUSE = "res://ui/menu_pause.tscn"
#const END_LEVEL_SCENE = preload("res://scenes/ui/LevelEnd.tscn")

var scene_ui_menu_main : PackedScene = null;
var scene_ui_menu_pause : PackedScene = null;

var main_scene : Node = null;
var ui_center_slot : CenterContainer = null;

var ui_main_menu : Node = null;
var ui_pause_menu : Node = null;


# Called when the node enters the scene tree for the first time.
func _ready():
	main_scene = get_tree().get_current_scene()
	ui_center_slot = main_scene.get_node("UICanvas/UICenterContainer")
	load_menus();
	open_main_menu()

func load_menus():
	scene_ui_menu_main = load(RES_UI_MENU_MAIN)
	scene_ui_menu_pause = load(RES_UI_MENU_PAUSE)

func quit_game():
	get_tree().quit()

func open_main_menu():
	clear_ui_center_slot()
	ui_main_menu = scene_ui_menu_main.instantiate()
	ui_center_slot.add_child(ui_main_menu)

func launch_solo_game():
	clear_ui_center_slot()

func return_to_main_menu():
	open_main_menu()

func pause_game():
	ui_pause_menu = scene_ui_menu_pause.instantiate()
	ui_center_slot.add_child(ui_pause_menu)
	get_tree().paused = true;
		
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
