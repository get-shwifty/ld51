extends CharacterBody2D

const SPEED = 200.0
const DEC = 2000.0

enum DeviceMap { KEYBOARD_ZQSD, KEYBOARD_ARROWS, CONTROLLER1, CONTROLLER2 }
var current_device = DeviceMap.KEYBOARD_ARROWS

func set_device_mode(new_device:DeviceMap):
	current_device = new_device

func _physics_process(delta):
	var direction = get_direction()
	if direction:
		rotation = direction.angle()
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	
func get_device_prefix():
	match current_device:
		DeviceMap.KEYBOARD_ZQSD:
			return "zqsd"
		DeviceMap.KEYBOARD_ARROWS:
			return "arrows"
		DeviceMap.CONTROLLER1:
			return "ctrl1"
		DeviceMap.CONTROLLER2:
			return "ctrl2"

func get_direction():
	var prefix = get_device_prefix()
	var direction = Vector2(
				Input.get_axis(prefix+"_left", prefix+"_right"),
				Input.get_axis(prefix+"_up", prefix+"_down"))
	direction.limit_length()
	
	return direction
