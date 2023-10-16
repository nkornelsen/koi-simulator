extends TextureButton


enum Tools { NewHex=0, Edit=1, AddKoi=2 }
@export var toolname = Tools.NewHex

var active = false
var mouse_over = false

var tool_textures = {
	Tools.NewHex: {
		"Normal": load("res://circle_icons/new_hex/new_hex_normal.svg"),
		"Active": load("res://circle_icons/new_hex/new_hex_active.svg"),
		"Hover": load("res://circle_icons/new_hex/new_hex_hover.svg")
	},
	Tools.Edit: {
		"Normal": load("res://circle_icons/edit/edit_normal.png"),
		"Active": load("res://circle_icons/edit/edit_active.png"),
		"Hover": load("res://circle_icons/edit/edit_hover.png")
	},
	Tools.AddKoi: {
		"Normal": load("res://circle_icons/add_koi/add_koi_normal.png"),
		"Active": load("res://circle_icons/add_koi/add_koi_active.png"),
		"Hover": load("res://circle_icons/add_koi/add_koi_hover.png")
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().active_button == toolname:
		self.set_texture_normal(tool_textures[toolname]["Active"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_pressed():
	for button in get_parent()._get_button_list():
		button.set_texture_normal(tool_textures[button.toolname]["Normal"])
		button.set_pressed_no_signal(false)
	self.set_texture_normal(tool_textures[toolname]["Active"])
	set_pressed_no_signal(true)
	get_parent()._set_mode(toolname)
	
func _on_mouse_entered():
	mouse_over = true
func _on_mouse_exited():
	mouse_over = false
func _mouse_over():
	return mouse_over
