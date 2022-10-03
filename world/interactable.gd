extends StaticBody2D
class_name Interactable

var current_character = null

func get_input_name(suffix):
	return DevicesHelper.get_device_prefix(current_character.current_device) + suffix

func is_interact_free():
	return current_character == null

func start_interact(character):
	current_character = character
	on_interact_start()

func on_interact_start():
	pass

func end_interact():
	on_interact_end()
	current_character = null

func on_interact_end():
	pass
