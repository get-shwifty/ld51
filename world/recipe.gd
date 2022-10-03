extends Node2D

var Menu: MenuRessource = GameParams.get_current_menu()

@onready var label: Label = $Label
@onready var iconMarker: Marker2D = $Icon
@onready var ingredientsMarker: Marker2D = $Ingredients

# Called when the node enters the scene tree for the first time.
func set_receipe(receipe_name):
	var menu_item: MenuItemRessource = Menu.recipes.filter(func(menu_item):
		return menu_item.recipe.name == receipe_name).front()
	
	if menu_item == null:
		return
	var recipe = menu_item.recipe
	
	for child in iconMarker.get_children():
		iconMarker.remove_child(child)
	for child in ingredientsMarker.get_children():
		ingredientsMarker.remove_child(child)
	
	label.text = recipe.name
	iconMarker.add_child(recipe.icon.instantiate())
	
	var i = 0
	for step in recipe.steps:
		for ing in step.ingredients:
			for j in range(ing.quantity):
				var ing_scene = ing.ingredient.icon.instantiate()
				ing_scene.position.x = i * 8
				i += 1
				ingredientsMarker.add_child(ing_scene)
		i += 1
