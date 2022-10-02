extends Node
class_name DevicesHelper

enum { KEYBOARD_ZQSD, KEYBOARD_ARROWS, CONTROLLER1, CONTROLLER2 }

static func get_device_prefix(device):
	match device:
		KEYBOARD_ZQSD:
			return "zqsd_"
		KEYBOARD_ARROWS:
			return "arrows_"
		CONTROLLER1:
			return "ctrl1_"
		CONTROLLER2:
			return "ctrl2_"
