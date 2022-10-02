extends CharacterBody2D

const SPEED = 200.0


### Variables


@onready var action_area: Area2D = $ActionArea
@onready var infoBulle: Node2D = $InfoBulle
@onready var takePosition: Marker2D = $TakeMarker

var current_interact_body = null
var current_object_taken = null


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
		var bodies = action_area.get_overlapping_bodies()
		# todo sort by distance
		
		if current_interact_body == null:
			for body in bodies:
				if body.has_method("is_interact_free") and body.is_interact_free():
					start_interact(body)
					break
				if current_object_taken == null and \
					body.has_method("is_takeable") and body.is_takeable():
					take(body)
					break
				if current_object_taken != null and \
					body.has_method("is_posable") and body.is_posable():
					untake(body)
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
	current_object_taken = body
	body.take(self)

func untake(pose_body):
	current_object_taken.untake(pose_body)
	current_object_taken = null

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
