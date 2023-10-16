extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var grid_offset = get_node("../BG/GridViewControl")._get_grid_offset() * 100.0
	var hex_width = get_node("../BG/GridViewControl")._get_hex_width()
	var hex_scale = hex_width / 100.0
	self.set_position(grid_offset)
	self.set_zoom(Vector2(hex_scale, hex_scale))

func _process(delta):
	var grid_offset = get_node("../BG/GridViewControl")._get_grid_offset() * 100.0
	var hex_width = get_node("../BG/GridViewControl")._get_hex_width()
	var hex_scale = hex_width / 100.0
	self.set_position(grid_offset)
	self.set_zoom(Vector2(hex_scale, hex_scale))

#func _input(ev):
#	var grid_offset = get_node("../../../BG/GridBackground").get_bg_grid_offset()
#	var hex_width = get_node("../../../BG/GridBackground").get_bg_hex_width()
#	if ev is InputEventMouseMotion:
#		if panning:
#			var hex_scale = hex_width / 100.0
#			grid_offset -= Vector2(ev.relative[0], ev.relative[1]) / hex_scale
#			self.position = grid_offset
#	if ev is InputEventMouseButton:
#		if ev.pressed && !panning:
#			if ev.button_index == MOUSE_BUTTON_WHEEL_UP:
#				hex_width = min(hex_width * 1.1, 50000.0);
#			elif ev.button_index == MOUSE_BUTTON_WHEEL_DOWN:
#				hex_width = max(hex_width / 1.1, 20.0);
#			var hex_scale = hex_width / 100.0
#			self.zoom = Vector2(hex_scale, hex_scale)
