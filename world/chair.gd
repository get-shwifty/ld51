extends StaticBody2D

const SPEED = 100.0

@onready var path_follow: PathFollow2D = $Path2d/PathFollow2d

var direction = 0
var active = false
var in_table = false

func move_in_client(client):
	if $Path2d.curve != null:
		path_follow.add_child(client)
		direction = 1
		active = true
		in_table = false
		path_follow.progress = 0
	else:
		active = true
		in_table = true
		path_follow.progress_ratio = 1
		add_child(client)

func move_out_client():
	if $Path2d.curve != null:
		direction = -1
		in_table = false
	else:
		active = false
		in_table = false
		path_follow.remove_child(path_follow.get_child(0))

func _process(delta):
	if direction != 0:
		path_follow.progress += delta * SPEED * direction
		if direction > 0 and path_follow.progress_ratio >= 1:
			direction = 0
			in_table = true
		if direction < 0 and path_follow.progress_ratio <= 0:
			direction = 0
			active = false
			path_follow.remove_child(path_follow.get_child(0))
