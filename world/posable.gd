extends Area2D
class_name Posable

func is_posable():
	return true # todo body overlap and body not taken

func get_tray():
	for body in get_overlapping_bodies():
		if body.is_in_group("tray") and body.is_takeable():
			return body
	return null
