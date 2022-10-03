extends CharacterBody2D

const SPEED = 130.0

@onready var Menu: MenuRessource = GameParams.get_current_menu()

### Variables

@onready var rotationNode: Node2D = $Rotation
@onready var actionArea: Area2D = $Rotation/ActionArea
@onready var tray: Tray = $Rotation/Tray
@onready var animatedSprite2D: AnimatedSprite2D = $Rotation/AnimatedSprite2D
@onready var infoBullePos: Marker2D = $Rotation/InfoBullePos
@onready var infoBulleMenuItems: Node2D = $InfoBulleMenuItems
@onready var infobubleCoffeeMachine: Node2D = $InfoBulleCoffeeMachine

var player_num: String = "0"

var current_interact_body = null


### Device Management


var current_device = DevicesHelper.KEYBOARD_ARROWS

func set_device_mode(new_device):
	current_device = new_device

func get_input_name(suffix):
	return DevicesHelper.get_device_prefix(current_device) + suffix


### Interactions

func _ready():
	infoBulleMenuItems.visible = false
	infobubleCoffeeMachine.visible = false

func comp_nearest(a, b):
	return to_local(a.global_position).length() < to_local(b.global_position).length()

func _process(delta):
	if Input.is_action_just_pressed(get_input_name("action")):
		var areas = actionArea.get_overlapping_areas()
		areas.sort_custom(comp_nearest)
		var bodies = actionArea.get_overlapping_bodies()
		bodies.sort_custom(comp_nearest)
		
		if current_interact_body == null:
			for body in areas + bodies:
				# interact with table only if tray is not empty
				if body.is_in_group("table"):
					if body.is_interact_free() and !tray.is_empty():
						start_interact(body)
						break
				# interact with something else
				elif body.has_method("is_interact_free") and body.is_interact_free():
					start_interact(body)
					break
					
				if body.is_in_group("tray"):
					# put objects on tray
					if !tray.is_empty() and body.has_free_place():
						put_objects_on(body)
						break
					# take objects from tray
					elif tray.is_empty() and !body.is_empty():
						take_objects_from(body)
						break
					
				# take an object
				if tray.has_free_place() and body.has_method("is_takeable") and !body.is_takeable():
					take(body)
					break
		else:
			end_interact()

func start_interact(body):
	body.start_interact(self)
	current_interact_body = body
	
	if current_interact_body.is_in_group("table"):
		if !tray.is_empty():
			infoBulleMenuItems.visible = true

	anim_idle()
	update_infobulle()

func end_interact():
	current_interact_body.end_interact()
	
	if current_interact_body.is_in_group("table"):
		infoBulleMenuItems.visible = false

	current_interact_body = null

	update_infobulle()

func take(body):
	var obj = body.remove_object()
	tray.add_object(obj)

	update_infobulle()

func take_objects_from(other_tray: Tray):
	while tray.has_free_place() and !other_tray.is_empty():
		var obj_idx = other_tray.get_last_object_idx()
		var obj = other_tray.remove_object(obj_idx)
		tray.add_object(obj)

	update_infobulle()

func put_objects_on(other_tray: Tray):
	while !tray.is_empty() and other_tray.has_free_place():
		var obj_idx = tray.get_last_object_idx()
		var obj = tray.remove_object(obj_idx)
		other_tray.add_object(obj)

	update_infobulle()

### Graphics

func set_texture(info_bulle):
	match current_device:
		DevicesHelper.KEYBOARD_ARROWS:
			infoBulleMenuItems.find_child("Background_arrows").texture = null
		DevicesHelper.KEYBOARD_ZQSD:
			infoBulleMenuItems.find_child("Background_arrows").texture = null
		DevicesHelper.CONTROLLER1:
			infoBulleMenuItems.find_child("Background_arrows").texture = null
		DevicesHelper.CONTROLLER2:
			infoBulleMenuItems.find_child("Background_arrows").texture = null

func update_infobulle():
	set_texture(infoBulleMenuItems)
	
	var positions = infoBulleMenuItems.find_children("pos?")
	for i in range(len(tray.objects)):
		var menu_item_instance = tray.get_object_at(i)
		
		if menu_item_instance == null:
			if positions[i].get_child_count() > 0:
				positions[i].remove_child(positions[i].get_child(0))
		else:
			var menu_item = Menu.recipes.filter(func(dish):
				return dish.recipe.name == menu_item_instance.menu_item_name).front()
			if menu_item:
				if positions[i].get_child_count() > 0:
					var icon_obj = positions[i].get_child(0)
					# if !(icon_obj is menu_item.icon):
					# TODO how to check if instance of a packedScene ?
					positions[i].remove_child(icon_obj)
					
				if positions[i].get_child_count() == 0:
					positions[i].add_child(menu_item.recipe.icon.instantiate())
			else:
				print_debug(menu_item_instance.menu_item_name + " not found")

func display_infobubble_coffee_machine():
	infobubleCoffeeMachine.visible = true

func hide_infobubble_coffee_machine():
	infobubleCoffeeMachine.visible = false

func update_infobubble_coffee_machine(available_ingredients):
	var positions = infobubleCoffeeMachine.find_children("pos?")

	for i in range(0,positions.size()):
		if positions[i].get_child_count() > 0:
			positions[i].remove_child(positions[i].get_child(0))
	
	if available_ingredients.size() > 0:
		var instance = available_ingredients[0].icon.instantiate()
		positions[0].add_child(instance)
	if available_ingredients.size() > 1:
		positions[1].add_child(available_ingredients[1].icon.instantiate())
	if available_ingredients.size() > 2:
		positions[2].add_child(available_ingredients[2].icon.instantiate())
	#if available_ingredients.size() > 3:
	#	positions[2].add_child(available_ingredients[3].icon.instantiate())


func anim_walk():
	animatedSprite2D.play("walk" + player_num)

func anim_idle():
	animatedSprite2D.play("idle" + player_num)

### Physics


func _physics_process(delta):
	if current_interact_body != null:
		return

	var direction = get_direction()
	if direction:
		rotationNode.rotation = direction.angle()
		infoBulleMenuItems.global_position = infoBullePos.global_position
		velocity = direction * SPEED
		anim_walk()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		anim_idle()

	move_and_slide()

func get_direction():
	var direction = Vector2(
				Input.get_axis(get_input_name("left"), get_input_name("right")),
				Input.get_axis(get_input_name("up"), get_input_name("down")))
	direction = direction.limit_length()
	
	return direction
