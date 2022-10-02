extends StaticBody2D
class_name Interactable

var current_device = null

func set_device_mode(new_device:DevicesHelper):
	current_device = new_device

func get_input_name(suffix):
	return DevicesHelper.get_device_prefix(current_device) + suffix

func is_interact_free():
	return current_device == null

func start_interact(new_device):
	current_device = new_device
	on_interact_start()

func on_interact_start():
	pass

func end_interact():
	current_device = null
	on_interact_end()

func on_interact_end():
	pass
