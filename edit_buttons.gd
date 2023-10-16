extends Control

var buttons = []
enum Tools { NewHex=0, Edit=1, AddKoi=2 }

var active_button = Tools.NewHex

# Called when the node enters the scene tree for the first time.
func _ready():
	buttons.append(get_node("NewHex"))
	buttons.append(get_node("Edit"))
	buttons.append(get_node("AddKoi"))
	get_node("../KoiValue").set_visible(false)
	get_node("../../KoiHandles").set_visible(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _get_button_list():
	return buttons

func _mouse_over_button():
	for node in get_children():
		if node._mouse_over():
			return true
	return false

func _get_mode():
	return active_button

func _set_mode(b):
	active_button = b
	if b == Tools.AddKoi:
		get_node("../../EditHandles").set_visible(false)
		get_node("../Tree").set_visible(false)
		get_node("../KoiValue").set_visible(true)
		get_node("../../KoiHandles").set_visible(true)
	else:
		get_node("../../EditHandles").set_visible(true)
		get_node("../Tree").set_visible(true)
		get_node("../KoiValue").set_visible(false)
		get_node("../../KoiHandles").set_visible(false)
