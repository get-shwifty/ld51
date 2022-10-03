extends StaticBody2D

const SPEED = 100.0

@onready var path_follow: PathFollow2D = $Path2d/PathFollow2d

var direction = 0
var active = false
var in_table = false
var client_scene = null

func move_in_client(client):
	if client_scene != null:
		path_follow.remove_child(client_scene)
	client_scene = client

	if $Path2d.curve != null:
		path_follow.add_child(client_scene)
		client_scene.anim.play("walk")
		direction = 1
		active = true
		in_table = false
		path_follow.progress = 0
	else:
		active = true
		in_table = true
		path_follow.progress_ratio = 1
		add_child(client_scene)

func move_out_client():
	if $Path2d.curve != null:
		direction = -1
		in_table = false
		client_scene.anim.play("walk")
	else:
		active = false
		in_table = false
		path_follow.remove_child(client_scene)
		client_scene = null

func _process(delta):
	if direction != 0:
		path_follow.progress += delta * SPEED * direction
		if direction > 0 and path_follow.progress_ratio >= 1:
			client_scene.anim.play("idle")
			direction = 0
			in_table = true
		if direction < 0 and path_follow.progress_ratio <= 0:
			client_scene.anim.play("idle")
			direction = 0
			active = false
			path_follow.remove_child(client_scene)
			client_scene = null
