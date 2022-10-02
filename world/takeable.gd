extends StaticBody2D
class_name Takeable

var current_character = null

func get_input_name(suffix):
	return DevicesHelper.get_device_prefix(current_character.current_device) + suffix

func is_takeable():
	return current_character == null

func take(character):
	current_character = character
	on_take()

func on_take():
	pass

func untake(pose_body):
	current_character = null
	global_position = pose_body.global_position
	on_untake()

func on_untake():
	pass

func _process(delta):
	if current_character != null:
		global_position = current_character.takePosition.global_position
