extends Interactable

const menu_item_scene = preload("res://world/menu_item.tscn")

@onready var info_bubble:Node2D = $InfoBubble
@onready var drop_zone: Takeable = $TakeablePos

func _ready():
	info_bubble.visible = false

func on_interact_start():
	info_bubble.visible = true
	print("interact coffee machine")

func on_interact_end():
	info_bubble.visible = false
	var menu_item_instance = menu_item_scene.instantiate()
	menu_item_instance.menu_item_name = "espresso"
	drop_zone.add_object(menu_item_instance)
	print("quit coffee machine")
