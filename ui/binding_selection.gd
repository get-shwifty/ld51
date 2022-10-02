extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var bindings_list = null;
var current_binding_index = 0;

func set_bindings_list(bindings):
	bindings_list = bindings
	refresh_bindings_display()

func refresh_bindings_display():
	$HBoxContainer/LabelBindingName.set_text(bindings_list[current_binding_index]["name"]);
	$LabelBindingDescription.set_text(bindings_list[current_binding_index]["description"]);

func get_current_binding_id():
	return bindings_list[current_binding_index]["id"];

func _on_button_left_pressed():
	current_binding_index -= 1
	if current_binding_index < 0:
		current_binding_index = bindings_list.size() - 1
	refresh_bindings_display()


func _on_button_right_pressed():
	current_binding_index += 1
	if current_binding_index >= bindings_list.size():
		current_binding_index = 0
	refresh_bindings_display()
