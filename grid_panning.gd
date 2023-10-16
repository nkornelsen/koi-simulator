extends Node

var grid_offset = Vector2()
var panning = false
var hex_width = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pan_grid") && !get_node("../../EditMode")._get_mouse_on_gui():
		panning = true
	if Input.is_action_just_released("pan_grid"):
		panning = false

func _input(ev):
	if ev is InputEventMouseMotion:
		if panning:
			grid_offset -= Vector2(ev.relative[0], ev.relative[1]) / hex_width
			get_node("../GridBackground").set_grid_offset(grid_offset);
	if ev is InputEventMouseButton && !get_node("../../EditMode")._get_mouse_on_gui():
		if ev.pressed && !panning:
			if ev.button_index == MOUSE_BUTTON_WHEEL_UP:
				hex_width = min(hex_width * 1.1, 50000.0);
			elif ev.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				hex_width = max(hex_width / 1.1, 20.0);
			get_node("../GridBackground").set_hex_width(hex_width);
			
func _get_grid_offset():
	return grid_offset
func _get_hex_width():
	return hex_width
