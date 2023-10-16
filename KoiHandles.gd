extends Node2D

var coords = Vector2i(0, 0)

var Koi = preload("res://koi.tscn")

var angles = [
	1,
	-1,
	-1,
	1,
	1,
	-1,
	-1,
	1,
	1,
	-1,
	-1,
	1
]

var koi_list

func idx_to_coord(i):
	var y = float(i.y)
	var x = float(i.x)
	if pingpong(y, 1.0) > 0.5:
		x += 0.5
	return Vector2(x, y*sqrt(3.0)/2.0)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	koi_list = get_node("/root/Control/Koi")
	var children = get_children()
	for i in len(children):
		children[i]._set_id(i)
		children[i].pivot_offset = Vector2(25.0, 25.0)
		children[i].scale = Vector2(0.25, 0.25)
		
		var angle_rad = -((i/2)*PI/3.0) + (-15.0 * angles[i] * PI/180.0)
		children[i].position = Vector2(-25.0, -25.0) + 38.0 * Vector2(cos(angle_rad), sin(angle_rad))
		children[i].rotation = -((i/2)*PI/3.0) + (-15.0 * angles[i] * PI/180.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_koi_button_press(id):
	var t = _get_tile()
	var prev_koi = t._get_slot(id)
	if prev_koi != null:
		# delete
		t._set_slot(id, null)
		prev_koi.queue_free()
	else:
		# new koi
		var k = Koi.instantiate()
		var value = get_node("/root/Control/EditMode/CanvasLayer/KoiValue/Input").get_text()
		if value.is_valid_int():
			k._set_value(int(value))
		else:
			k._set_value(0)
		t._set_slot(id, k)
		k._set_location(t, id)
		get_node("/root/Control/Koi").add_child(k)
	
func _get_tile():
	return get_node("/root/Control/Tiles")._get_tile(coords)

func _on_coords_new_hex_hovered(c):
	coords = c
	if _get_tile() == null:
		for child in get_children():
			child.set_visible(false)
	else:
		for child in get_children():
			child.set_visible(true)
		self.position = 100.0 * idx_to_coord(c) * Vector2(1.0, -(2.0 / ( 1.15 * sqrt(3.0))))
