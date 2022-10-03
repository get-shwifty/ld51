extends Interactable
class_name World_Table

var receipes: Array[String] = []

var clients_scenes: Array[PackedScene] = [
	preload("res://world/client1.tscn"),
	preload("res://world/client2.tscn")
]

var Menu: MenuRessource = preload("res://data/menu/menu.tres")

@onready var infoBulle: Node2D = $InfoBulle
@onready var infoBulleLabel: Label = $InfoBulle/Label
@onready var chairs: Array = $Chairs.get_children()
@onready var characterDetector: Area2D = $CharacterDetector

var current_clients: Array = []

func _ready():
	for dish in Menu.recipes:
		if dish.recipe.name == "Failed coffee":
			continue
		receipes.push_back(dish.recipe.name)
	infoBulle.visible = false

func is_empty():
	return current_clients.size() == 0

func is_interact_free():
	return super() and !is_empty()

func _process(delta):
	if current_character != null and !is_empty():
		var buttons_pressed = []
		if Input.is_action_just_pressed(get_input_name("up")):
			buttons_pressed.push_back(0)
		if Input.is_action_just_pressed(get_input_name("down")):
			buttons_pressed.push_back(2)
		if Input.is_action_just_pressed(get_input_name("left")):
			buttons_pressed.push_back(3)
		if Input.is_action_just_pressed(get_input_name("right")):
			buttons_pressed.push_back(1)
		
		if buttons_pressed.size() > 0:
			for button in buttons_pressed:
				var menu_item = current_character.tray.remove_object(button)
				if menu_item != null:
					var remove_index = current_clients.find(menu_item.menu_item_name)
					if remove_index >= 0:
						current_clients.remove_at(remove_index)
					else:
						print("TODO feedback bad menu item delivered")

			update_infobulle()
			current_character.update_infobulle()

			if current_clients.size() == 0:
				# table is done!
				for i in range(chairs.size()):
					if chairs[i].client_scene != null:
						chairs[i].remove_child(chairs[i].client_scene)
						chairs[i].client_scene = null
				current_character.end_interact()
			elif current_character.tray.is_empty():
				current_character.end_interact()

func create_clients(nb_clients):
	current_clients = []
	for i in range(nb_clients):
		current_clients.push_back(receipes[randi() % len(receipes)])
		var client_scene = clients_scenes[randi() % len(clients_scenes)].instantiate()
		chairs[i].client_scene = client_scene
		chairs[i].add_child(client_scene)
	
	update_infobulle()

func update_infobulle():
	infoBulle.visible = !is_empty() and \
		len(characterDetector.get_overlapping_bodies()) > 0
	if infoBulle.visible:
		infoBulleLabel.text = ""
		for client in current_clients:
			infoBulleLabel.text += client + "\n"

func _on_character_detector_body_entered(body):
	update_infobulle()

func _on_character_detector_body_exited(body):
	update_infobulle()
