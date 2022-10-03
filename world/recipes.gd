extends Node2D

const NB_RECIPES_PER_LINE = 6
const RECIPE_W = 96
const RECIPE_H = 32

var Menu: MenuRessource = preload("res://data/menu/menu.tres")
var RecipeScene: PackedScene = preload("res://world/recipe.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	update_recipes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_recipes():
	for child in get_children():
		remove_child(child)
		
	var recipes_names = Menu.recipes.map(func(r): return r.recipe.name)
	recipes_names.pop_front() # remove coffee failed
	for i in range(recipes_names.size()):
		var child = RecipeScene.instantiate()
		add_child(child)
		child.position.x = (i % NB_RECIPES_PER_LINE) * RECIPE_W
		child.position.y = floori(i / NB_RECIPES_PER_LINE) * RECIPE_H
		child.set_receipe(recipes_names[i])
