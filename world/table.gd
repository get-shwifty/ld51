extends Interactable
class_name World_Table

@onready var infoBulle: Node2D = $InfoBulle
@onready var chairs: Array = $Chairs.get_children()

var current_clients = null

func _ready():
	infoBulle.visible = false

func on_interact_start():
	infoBulle.visible = true
	print("interact table")

func on_interact_end():
	infoBulle.visible = false
	print("quit table")

func create_clients(nb_clients):
	
