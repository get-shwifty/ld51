extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	frame = randi_range(0, 18)
	speed_scale = randf_range(0.8, 1.2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
