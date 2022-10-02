extends StaticBody2D
class_name Tray

@onready var sprite: Sprite2D = $Sprite2d
@onready var objects_poses: Node2D = $Objects

var objects = [null, null, null, null]

func _ready():
	if is_empty():
		sprite.visible = !is_empty()

func get_object_at(place):
	return objects[place]

func get_free_place():
	for i in range(len(objects)):
		if objects[i] == null:
			return i
	return -1

func get_last_object_idx():
	for i in range(len(objects)-1, -1, -1):
		if objects[i] != null:
			return i
	return -1
	
func is_empty():
	for obj in objects:
		if obj != null:
			return false
	return true

func has_free_place():
	return get_free_place() >= 0

func add_object(obj):
	var free_place = get_free_place()
	if free_place < 0:
		return -1
	objects[free_place] = obj
	
	var container = objects_poses.get_child(free_place)
	container.add_child(objects[free_place])
	sprite.visible = true
	
	return free_place

func remove_object(place):
	var obj = objects[place]
	objects[place] = null
	
	var container = objects_poses.get_child(place)
	container.remove_child(obj)
	sprite.visible = !is_empty()
	
	return obj
