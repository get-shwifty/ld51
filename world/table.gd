extends Interactable
class_name World_Table

const TIMER_DRINKING_MIN = 3.0
const TIMER_DRINKING_MAX = 8.0

var receipes: Array[String] = []

var clients_scenes: Array[PackedScene] = [
	preload("res://world/client1.tscn"),
	preload("res://world/client2.tscn"),
	preload("res://world/client3.tscn"),
	preload("res://world/client4.tscn")
]

signal coffee_served(coffee_name)
signal bad_coffee_served()

@onready var Menu: MenuRessource = GameParams.get_current_menu()

@onready var infoBulle: Node2D = $InfoBulle
@onready var infoBulleLabel: Label = $InfoBulle/Label
@onready var chairs: Array = $Chairs.get_children()
@onready var characterDetector: Area2D = $CharacterDetector
@onready var coffees: Node2D = $Coffees

var current_clients: Array = []
var nb_clients = 0
var drinking_timer = null

func _ready():
	for dish in Menu.recipes:
		if dish.recipe.name == "Failed coffee":
			continue
		receipes.push_back(dish.recipe.name)
	infoBulle.visible = false

func are_clients_on_table():
	for chair in chairs:
		if chair.active == true and chair.in_table == false:
			return false
	return true

func are_client_out():
	for chair in chairs:
		if chair.active == true:
			return false
	return true

func is_empty():
	return current_clients.size() == 0 and nb_clients == 0

func is_interact_free():
	return super() and current_clients.size() > 0 and nb_clients > 0 and are_clients_on_table()

func _process(delta):
	if current_character != null and current_clients.size() > 0:
		var buttons_pressed = []
		if Input.is_action_just_pressed(get_input_name("action_up")):
			buttons_pressed.push_back(0)
		#if Input.is_action_just_pressed(get_input_name("action_down")):
		#	buttons_pressed.push_back(2)
		if Input.is_action_just_pressed(get_input_name("action_left")):
			buttons_pressed.push_back(2)
		if Input.is_action_just_pressed(get_input_name("action_right")):
			buttons_pressed.push_back(1)
		
		if buttons_pressed.size() > 0:
			$Serve.play()
			for button in buttons_pressed:
				var menu_item = current_character.tray.remove_object(button)
				if menu_item != null:
					var remove_index = current_clients.find(menu_item.menu_item_name)
					if remove_index >= 0:
						coffee_served.emit(menu_item.menu_item_name)
						# remove coffee from the table list
						current_clients.remove_at(remove_index)
						
						# add coffee onto the table
						var free_places = coffees.get_children()
						free_places.resize(nb_clients)
						free_places = free_places.filter(func(coffee):
							return coffee.get_child_count() == 0)
						if free_places.size() > 0:
							var free_place = free_places[randi() % free_places.size()]
							free_place.add_child(menu_item)
					else:
						bad_coffee_served.emit()
						print("TODO feedback bad menu item delivered")

			update_infobulle()
			current_character.update_infobulle()

			if current_clients.size() == 0 and drinking_timer == null:
				# table is done!
				drinking_timer = get_tree().create_timer(
					randf_range(TIMER_DRINKING_MIN, TIMER_DRINKING_MAX))
				
				current_character.end_interact()
			elif current_character.tray.is_empty():
				current_character.end_interact()

	if drinking_timer != null and drinking_timer.get_time_left() <= 0:
		# table is done!
		for i in range(chairs.size()):
			if chairs[i].in_table == true:
				chairs[i].move_out_client()
		
		for coffee in coffees.get_children():
			for child in coffee.get_children():
				coffee.remove_child(child)
		
		drinking_timer = null
		update_infobulle()
	
	if current_clients.size() == 0 and drinking_timer == null and nb_clients > 0:
		if are_client_out():
			nb_clients = 0
	
	update_infobulle()

func create_clients(nb):
	nb_clients = nb
	current_clients = []
	for i in range(nb_clients):
		current_clients.push_back(receipes[randi() % len(receipes)])
		var client_scene = clients_scenes[randi() % len(clients_scenes)].instantiate()
		chairs[i].move_in_client(client_scene)
	
	update_infobulle()

func update_infobulle():
	infoBulle.visible = current_clients.size() > 0 and are_clients_on_table() and \
		len(characterDetector.get_overlapping_bodies()) > 0
	if infoBulle.visible:
		infoBulleLabel.text = ""
		for client in current_clients:
			infoBulleLabel.text += client + "\n"

func _on_character_detector_body_entered(body):
	update_infobulle()

func _on_character_detector_body_exited(body):
	update_infobulle()
