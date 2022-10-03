extends Node2D

@onready var door: AnimatedSprite2D = $DoorSprite
@onready var area: Area2D = $Area2d

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func open():
	door.speed_scale = 1

func close():
	door.speed_scale = -1

func _on_area_2d_body_entered(body):
	if area.get_overlapping_bodies().size() == 1:
		$Ring.play()
	open()

func _on_area_2d_body_exited(body):
	if area.get_overlapping_bodies().size() == 0:
		close()
