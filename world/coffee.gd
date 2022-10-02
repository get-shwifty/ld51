extends AnimatedSprite2D

func _ready():
	frame = randi_range(0, frames.get_frame_count("default"))
