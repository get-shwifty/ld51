extends Area2D
class_name Takeable

@onready var current_object = $Coffee

func is_takeable():
	return current_object == null
	
func add_object(obj):
	current_object = obj
	add_child(obj)
	return obj

func remove_object():
	var obj = current_object
	remove_child(obj)
	current_object = null
	return obj
