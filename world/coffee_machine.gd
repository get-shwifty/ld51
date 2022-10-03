extends Interactable

const MENU_ITEM_SCENE = preload("res://world/menu_item.tscn")

@onready var Menu: MenuRessource = GameParams.get_current_menu()
const FAILED_RECIPE = preload("res://data/menu/menu_items/coffee_failed.tres")

const INGREDIENTS_AVAILABLE_BY_STEPS = [
	[
		preload("res://data/menu/ingredients/coffee.tres"),
		preload("res://data/menu/ingredients/water.tres"),
		preload("res://data/menu/ingredients/chocolate.tres")
	],
	[
		preload("res://data/menu/ingredients/milk.tres"),
		preload("res://data/menu/ingredients/foamed_milk.tres")
	],
]

@onready var info_bubble:Node2D = $InfoBubble
@onready var info_bubble_ingredients: GridContainer = $InfoBubble/IngredientsIcons
@onready var info_bubble_loading: Node2D = $InfoBubble/BackgroundLoading
@onready var drop_zone: Takeable = $TakeablePos

#Array[Array[IngredientRessource]] is the type but nested typed collection aren't supported
var current_preparation = []
var current_preparation_step = -1

var loading_time_total = 0
var loading_time_remaining = 0

func is_coffe_in_front():
	#todo ugly, refactor this
	return drop_zone.get_child_count() > 1

func is_interact_free():
	return super() and loading_time_remaining <= 0 and not is_coffe_in_front()

func reset_prepation():
	current_preparation = []
	current_preparation_step = -1
	for child in info_bubble_ingredients.get_children():
		child.queue_free()
	reset_loading()

func reset_loading():
	loading_time_total = 0
	loading_time_remaining = 0
	refresh_loading_ratio()

func refresh_loading_ratio():
	var loading_scale = info_bubble_loading.scale
	if loading_time_total == 0:
		loading_scale.y = 0
	else:
		loading_scale.y = 1.2 - (loading_time_remaining/loading_time_total)*1.2;
	info_bubble_loading.scale = loading_scale

func start_loading(total):
	loading_time_total = total
	loading_time_remaining = total

func preparation_next_step():
	current_preparation.push_back([])
	current_preparation_step += 1

func _ready():
	info_bubble.visible = false
	reset_prepation()

func _process(delta):
	handle_info_bubble_movement()
	if loading_time_remaining > 0:
		loading_time_remaining -= delta
		refresh_loading_ratio()
		if loading_time_remaining <= 0:
			$Finish.play()
	if super.is_interact_free():
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
	if current_preparation[-1].size() == 8:
		return;
	
	current_preparation[-1].push_back(ingredient)
	var icon =  TextureRect.new();
	icon.set_texture(ingredient.icon_texture)
	info_bubble_ingredients.add_child(icon)
	$Ingredient.play()
	print("Adding ingredient "+ ingredient.name)

func handle_info_bubble_movement():
	var additional_ratio = 1
	var amplitude = 2
	if loading_time_remaining > 0:
		additional_ratio = 3
	elif loading_time_remaining < 0:
		additional_ratio = 5
		amplitude = 4
	
	var base_ratio = 0.001
	var now = Time.get_ticks_msec()
	var position = $InfoBubbleRoot.position
	position.x = position.x + (cos(now*base_ratio*additional_ratio)+1)*amplitude
	$InfoBubble.set_position(position)
	


func on_interact_start():
	info_bubble.visible = true
	reset_loading()
	preparation_next_step()
	
	#hack for ludum dare
	if GameParams.get_current_difficulty().id == "easy":
		if current_preparation_step == 1:
			current_character.call_deferred("end_interact")
			return;
	
	current_character.update_infobubble_coffee_machine(INGREDIENTS_AVAILABLE_BY_STEPS[current_preparation_step])
	current_character.display_infobubble_coffee_machine()
	print("interact coffee machine : prepation step " + str(current_preparation_step))
	
	

func on_interact_end():
	var recipes = get_recipes_matching_current_preparation(Menu.recipes, current_preparation_step)
	
	current_character.hide_infobubble_coffee_machine()
	
	print("quiting coffee machine, recipes available below :")
	for recipe in recipes:
		print(recipe.recipe.name)
	
	if current_preparation_step == 0 and current_preparation[0].size() == 0:
		info_bubble.visible = false
		reset_prepation() #nothing prepared, leave the machine like you didn't interact with it
	elif current_preparation_step + 1 == INGREDIENTS_AVAILABLE_BY_STEPS.size():
		var preparation_name = "unknown"
		
		if recipes.size() == 0:
			preparation_name = FAILED_RECIPE.name
		elif recipes.size() == 1:
			preparation_name = recipes[0].recipe.name
		else:
			push_error("Too many recipes are matching, this should not be possible")
			
		var menu_item_instance = MENU_ITEM_SCENE.instantiate()
		menu_item_instance.set_menu_item_name(preparation_name)
		
		if current_character.tray.has_free_place():
			current_character.tray.add_object(menu_item_instance)
		else:
			drop_zone.add_object(menu_item_instance)
		
		print(preparation_name + " ready")
		info_bubble.visible = false
		reset_prepation()
	else:
		#TODO this should be taken from the menu data
		start_loading(3)
	



func get_recipes_matching_current_preparation(recipe_list : Array[MenuItemRessource], check_until_step: int = -1):
	return recipe_list.filter(func(r): return do_preparation_match_recipe(current_preparation,r.recipe, check_until_step))

func do_preparation_match_recipe(preparation, recipe : RecipeRessource, check_until_step: int):
#	print("evaluating match for " + recipe.name)
	var limit = max(recipe.steps.size(), preparation.size())
	if check_until_step != -1:
		limit = min(limit,check_until_step+1)
#	print("    step limit is " + str(limit))
	for i in range(0, limit):
#		print("    evaluating step " + str(i))
		if preparation.size() <= i:
#			print("        preparation has fewer steps than recipe")
			return false
		if recipe.steps.size() <= i:
			if preparation[i].size() != 0:
#				print("        preparation has more steps than recipe")
				return false
			else:
				continue
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

func _on_area_2d_area_entered(area):
	$Area2d/Contour.visible = true

func _on_area_2d_area_exited(area):
	if $Area2d.get_overlapping_areas().size() == 0:
		$Area2d/Contour.visible = false
