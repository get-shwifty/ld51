extends Interactable

const coffee_scene = preload("res://world/coffee.tscn")

@onready var info_bubble:Node2D = $InfoBubble
@onready var drop_zone: Node2D = $TakeablePos

func _ready():
	info_bubble.visible = false

func on_interact_start():
	info_bubble.visible = true
	print("interact coffee machine")

func on_interact_end():
	info_bubble.visible = false
	var coffee_instance = coffee_scene.instantiate()
	drop_zone.add_child(coffee_instance)
	print("interact coffee machine")
