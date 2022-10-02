extends CharacterBody2D

const SPEED = 200.0


### Variables


@onready var action_area: Area2D = $ActionArea
@onready var infoBulle: Node2D = $InfoBulle

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
	if current_interact_body == null:
		if Input.is_action_just_pressed(get_input_name("action")):
			var bodies = action_area.get_overlapping_bodies()
			# todo sort by distance
			for body in bodies:
				if body.has_method("is_interact_free") and body.is_interact_free():
					start_interact(body)
					break
	else:
		if Input.is_action_just_pressed(get_input_name("action")):
			end_interact()

func start_interact(body):
	infoBulle.visible = true
	body.start_interact(current_device)
	current_interact_body = body

func end_interact():
	infoBulle.visible = false
	current_interact_body.end_interact()
	current_interact_body = null

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
