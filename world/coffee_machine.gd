extends Interactable

const MENU_ITEM_SCENE = preload("res://world/menu_item.tscn")

const MENU : MenuRessource = preload("res://data/menu/menu.tres")
const FAILED_RECIPE = preload("res://data/menu/menu_items/coffee_failed.tres")

const INGREDIENTS_AVAILABLE_BY_STEPS = [
	[
		preload("res://data/menu/ingredients/coffee.tres"),
		preload("res://data/menu/ingredients/water.tres"),
	],
	[
		preload("res://data/menu/ingredients/milk.tres"),
	],
]

@onready var info_bubble:Node2D = $InfoBubble
@onready var drop_zone: Takeable = $TakeablePos

#Array[Array[IngredientRessource]] is the type but nested typed collection aren't supported
var current_preparation = []
var current_preparation_step = -1

func reset_prepation():
	current_preparation = []
	current_preparation_step = -1

func preparation_next_step():
	current_preparation.push_back([])
	current_preparation_step += 1

func _ready():
	info_bubble.visible = false
	reset_prepation()

func _process(delta):
	if is_interact_free():
		return
	
	var available_ingredients = INGREDIENTS_AVAILABLE_BY_STEPS[current_preparation_step];
	var available_number = available_ingredients.size()
	
	if Input.is_action_just_pressed(get_input_name("left")):
		if available_number > 0:
			add_ingredient(available_ingredients[0])
	if Input.is_action_just_pressed(get_input_name("right")):
		if available_number > 1:
			add_ingredient(available_ingredients[1])
	if Input.is_action_just_pressed(get_input_name("up")):
		if available_number > 2:
			add_ingredient(available_ingredients[2])
	if Input.is_action_just_pressed(get_input_name("down")):
		if available_number > 3:
			add_ingredient(available_ingredients[3])

func add_ingredient(ingredient : IngredientRessource):
	current_preparation[-1].push_back(ingredient)
	print("Adding ingredient "+ ingredient.name)


func on_interact_start():
	info_bubble.visible = true
	preparation_next_step()
	print("interact coffee machine : prepation step " + str(current_preparation_step))

func on_interact_end():
	info_bubble.visible = false
	
	var recipes = get_recipes_matching_current_preparation(MENU.recipes, current_preparation_step)
	
	print("quiting coffee machine, recipes available below :")
	for recipe in recipes:
		print(recipe.name)
	
	if current_preparation_step + 1 == INGREDIENTS_AVAILABLE_BY_STEPS.size():
		
		var menu_item_instance = MENU_ITEM_SCENE.instantiate()
		menu_item_instance.menu_item_name = "Espresso"
		drop_zone.add_object(menu_item_instance)
		
		print("preparation ready")
		reset_prepation()
	



func get_recipes_matching_current_preparation(recipe_list : Array[RecipeRessource], check_until_step: int = -1):
	return recipe_list.filter(func(r): return do_preparation_match_recipe(current_preparation,r, check_until_step))

func do_preparation_match_recipe(preparation, recipe : RecipeRessource, check_until_step: int):
	var limit = recipe.steps.size()
	if check_until_step != 1:
		limit = min(limit,check_until_step+1)
	for i in range(0, limit):
		if preparation.size() <= i:
			return false
		if not do_ingredients_match_step(preparation[i], recipe.steps[i]):
			return false
	return true

func do_ingredients_match_step(ingredient_list, step : RecipeStepRessource):
	for ingredient_quantity in step.ingredients:
		var ingredient = ingredient_quantity.ingredient
		var quantity = ingredient_quantity.quantity
		if ingredient_list.filter(func(i): return i.name == ingredient.name).size() != quantity:
			return false
	for ingredient in ingredient_list:
		if step.ingredients.filter(func(iq): return iq.ingredient.name == ingredient.name ).size() == 0:
			return false;
	return true;


