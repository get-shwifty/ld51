extends Node2D

@export var menu_item_name: String = ""

func set_menu_item_name(new_name):
	var coffee : AnimatedSprite2D = $Coffee
	menu_item_name = new_name
	if menu_item_name == "Failed coffee":
		coffee.animation = "failed"
		coffee.play()
	else:
		coffee.animation = "default"
		coffee.play()
