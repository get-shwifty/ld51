extends Control
class_name HUD

@onready var combo_label : Label = $ComboLabel;
@onready var time_label : Label = $TimeLabel;
@onready var score_label : Label = $ScoreLabel;

func format_time_string(time):
	time = int(floor(time))
	var minutes = time % 60
	var hours = time /60
	var res = "{hours}:{minutes}".format({"hours":"%02d" % hours, "minutes":"%02d" % minutes})
	return res

func set_time_progression(time_passed):
	var closes_at = 11*60
	var opens_at = closes_at - GameParams.GAME_DURATION
	var current_time = opens_at + time_passed
	time_label.set_text(format_time_string(current_time))

func set_combo(combo):
	if combo == 0:
		combo_label.set_text("")
	else:
		combo_label.set_text("Combo x"+str(combo))

func set_score(score):
	if score == 0:
		score_label.set_text("")
	else:
		score_label.set_text(str(score))

func _ready():
	set_time_progression(0)
	set_combo(0)
	set_score(0)
