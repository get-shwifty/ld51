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
	for dish in Menu.dishes:
		if dish.name == "Failed coffee":
			continue
		receipes.push_back(dish.name)
	infoBulle.visible = false

func is_empty():
	return len(current_clients) == 0

func is_interact_free():
	return super() and !is_empty()

func on_interact_start():
	print("interact table")

func on_interact_end():
	print("quit table")

func create_clients(nb_clients):
	current_clients = []
	for i in range(nb_clients):
		current_clients.push_back(receipes[randi() % len(receipes)])
		var client_scene = clients_scenes[randi() % len(clients_scenes)].instantiate()
		chairs[i].add_child(client_scene)
	
	infoBulleLabel.text = ""
	for client in current_clients:
		infoBulleLabel.text += client + "\n"
	
	check_visibility()

func check_visibility():
	infoBulle.visible = !is_empty() and \
		len(characterDetector.get_overlapping_bodies()) > 0

func _on_character_detector_body_entered(body):
	check_visibility()

func _on_character_detector_body_exited(body):
	check_visibility()
