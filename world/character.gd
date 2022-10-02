extends CharacterBody2D

const SPEED = 130.0


### Variables

@onready var rotationNode: Node2D = $Rotation
@onready var actionArea: Area2D = $Rotation/ActionArea
@onready var tray: Tray = $Rotation/Tray
@onready var animatedSprite2D: AnimatedSprite2D = $Rotation/AnimatedSprite2D
@onready var infoBullePos: Marker2D = $Rotation/InfoBullePos
@onready var infoBulleMenuItems: Node2D = $InfoBulleMenuItems

var current_interact_body = null


### Device Management


var current_device = DevicesHelper.KEYBOARD_ARROWS

func set_device_mode(new_device:DevicesHelper):
	current_device = new_device

func get_input_name(suffix):
	return DevicesHelper.get_device_prefix(current_device) + suffix


### Interactions

func _ready():
	infoBulleMenuItems.visible = false

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
				# interact with something
				if body.has_method("is_interact_free") and body.is_interact_free():
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
				elif tray.has_free_place() and body.has_method("is_takeable") and !body.is_takeable():
					take(body)
					break
		else:
			end_interact()
	
	update_graphics(delta)

func start_interact(body):
	body.start_interact(self)
	current_interact_body = body
	
	if current_interact_body.is_in_group("table"):
		if !tray.is_empty():
			infoBulleMenuItems.visible = true

func end_interact():
	current_interact_body.end_interact()
	
	if current_interact_body.is_in_group("table"):
		infoBulleMenuItems.visible = false

	current_interact_body = null

func take(body):
	var obj = body.remove_object()
	tray.add_object(obj)

func take_objects_from(other_tray: Tray):
	while tray.has_free_place() and !other_tray.is_empty():
		var obj_idx = other_tray.get_last_object_idx()
		var obj = other_tray.remove_object(obj_idx)
		tray.add_object(obj)

func put_objects_on(other_tray: Tray):
	while !tray.is_empty() and other_tray.has_free_place():
		var obj_idx = tray.get_last_object_idx()
		var obj = tray.remove_object(obj_idx)
		other_tray.add_object(obj)


### Graphics


func update_graphics(delta):
	var positions = infoBulleMenuItems.find_children("pos?")
	for i in range(len(tray.objects)):
		var menu_item = tray.get_object_at(i)
		if menu_item == null:
			if positions[i].get_child_count() > 0:
				positions[i].remove_child(positions[i].get_child(0))
		else:
			if positions[i].get_child_count() > 0:
				var icon_obj = positions[i].get_child(0)
				# TODO remove icon_obj if !(icon_obj is menu_item.icon_scene)
				
			if positions[i].get_child_count() == 0:
				pass # instantiate new menu_item.icon_scene


### Physics


func _physics_process(delta):
	if current_interact_body != null:
		return

	var direction = get_direction()
	if direction:
		rotationNode.rotation = direction.angle()
		infoBulleMenuItems.global_position = infoBullePos.global_position
		velocity = direction * SPEED
		animatedSprite2D.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		animatedSprite2D.play("idle")

	move_and_slide()

func get_direction():
	var direction = Vector2(
				Input.get_axis(get_input_name("left"), get_input_name("right")),
				Input.get_axis(get_input_name("up"), get_input_name("down")))
	direction = direction.limit_length()
	
	return direction
