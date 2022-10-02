extends Interactable
class_name World_Table

const receipes = ["espresso", "doppio", "cafe_au_lait"]

var clients_scenes: Array[PackedScene] = [
	preload("res://world/client1.tscn"),
	preload("res://world/client2.tscn")
]

@onready var infoBulle: Node2D = $InfoBulle
@onready var infoBulleLabel: Label = $InfoBulle/Label
@onready var chairs: Array = $Chairs.get_children()

var current_clients: Array = []

func _ready():
	infoBulle.visible = false

func is_empty():
	return len(current_clients) == 0

func on_interact_start():
	infoBulle.visible = true
	print("interact table")

func on_interact_end():
	infoBulle.visible = false
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
