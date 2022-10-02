extends CharacterBody2D

const SPEED = 200.0


### Variables

@onready var action_area: Area2D = $ActionArea
@onready var infoBulle: Node2D = $InfoBulle
@onready var tray: Tray = $Tray

var current_interact_body = null


### Device Management


var current_device = DevicesHelper.KEYBOARD_ARROWS

func set_device_mode(new_device:DevicesHelper):
	current_device = new_device

func get_input_name(suffix):
	return DevicesHelper.get_device_prefix(current_device) + suffix


### Interactions


func _ready():
	infoBulle.visible = false

func _process(delta):
	if Input.is_action_just_pressed(get_input_name("action")):
		var areas = action_area.get_overlapping_areas()
		var bodies = action_area.get_overlapping_bodies()
		# todo sort by distance
		
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

func start_interact(body):
	infoBulle.visible = true
	body.start_interact(self)
	current_interact_body = body

func end_interact():
	infoBulle.visible = false
	current_interact_body.end_interact()
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

### Physics

func _physics_process(delta):
	if current_interact_body != null:
		return

	var direction = get_direction()
	if direction:
		rotation = direction.angle()
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func get_direction():
	var direction = Vector2(
				Input.get_axis(get_input_name("left"), get_input_name("right")),
				Input.get_axis(get_input_name("up"), get_input_name("down")))
	direction.limit_length()
	
	return direction
