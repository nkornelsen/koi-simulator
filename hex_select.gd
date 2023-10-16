extends Label

var current_hex = Vector2i(0, 0)
var selected_hex = Vector2i(0, 0)
signal new_hex_selected
signal new_hex_hovered(c: Vector2i)

func pingpong(f, scale):
	return scale - abs(fmod(abs(f), 2.0*scale) - scale)

func coord_to_idx(c):
	var y = c.y * 2.0 / sqrt(3.0)
	var x = c.x
	if pingpong(y, 1.0) > 0.5:
		x -= 0.5
	return Vector2i(int(round(x)), int(round(y)))
	
func idx_to_coord(i):
	var y = float(i.y)
	var x = float(i.x)
	if pingpong(y, 1.0) > 0.5:
		x += 0.5
	return Vector2(x, y*sqrt(3.0)/2.0)

func adjacent_hexs(idx):
	var offsets = [
		Vector2i(-1, 1),
		Vector2i(0, 1),
		Vector2i(-1, 0),
		Vector2i(1, 0),
		Vector2i(-1, -1),
		Vector2i(0, -1)
	]
	
	var outputs = []
	for i in 6:
		if offsets[i].y == 0:
			outputs.append(idx + offsets[i])
		else:
			if pingpong(float(idx.y), 1.0) > 0.5:
				outputs.append(idx + offsets[i] + Vector2i(1, 0))
			else:
				outputs.append(idx + offsets[i])
	return outputs
	
func get_hex(coord):
	var base_idx = coord_to_idx(coord)
	var best_dist = idx_to_coord(base_idx).distance_to(coord)
	var hex_vec = idx_to_coord(base_idx)
	var adjacent = adjacent_hexs(base_idx)
	for i in 6:
		var hex_center = idx_to_coord(adjacent[i])
		var d = hex_center.distance_to(coord)
		if d < best_dist:
			hex_vec = hex_center
			best_dist = d
	var hex_idx = coord_to_idx(hex_vec)
	return hex_idx
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _input(ev):
	var grid_offset = get_node("../../../BG/GridBackground").get_bg_grid_offset()
	var rect_size = get_node("../../../BG/GridBackground").get_bg_grid_size()
	var hex_width = get_node("../../../BG/GridBackground").get_bg_hex_width()
	if ev is InputEventMouseMotion:	
		# position to hex space
		var center = Vector2(rect_size[0], rect_size[1]) / 2.0
		var grid_pixel_coord = ((Vector2(ev.position) - center) / hex_width) + grid_offset
		grid_pixel_coord = Vector2(grid_pixel_coord.x, -grid_pixel_coord.y * (1.15 * sqrt(3)) / 2.0)
		
		var new_hex = get_hex(Vector2(grid_pixel_coord))
		if current_hex != new_hex:
			current_hex = new_hex
			new_hex_hovered.emit(current_hex)
			self.text = "Hover: " + str(current_hex) + "\nSelected: " + str(selected_hex)
	if ev is InputEventMouseButton:
		if ev.pressed && ev.button_index == MOUSE_BUTTON_LEFT && !get_node("../..")._get_mouse_on_gui():
			_set_selected(current_hex)
			new_hex_selected.emit()

func _set_selected(hex):
	selected_hex = hex
	self.text = "Hover: " + str(current_hex) + "\nSelected: " + str(selected_hex)
	get_node("../../SelectionOverlay").position = Vector2(-255.0, -294.0) + 100.0 * idx_to_coord(selected_hex) * Vector2(1.0, -(2.0 / ( 1.15 * sqrt(3.0))))

func _get_selected():
	return selected_hex

func _get_hovered():
	return current_hex
