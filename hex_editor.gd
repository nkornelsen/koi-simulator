extends Node

enum Tools { NewHex=0, Edit=1, AddKoi=2 }

var hex_ids = preload("res://hexes/hex_ids.gd")
var hex_scenes = preload("res://hexes/hex_scenes.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var TRANSITION_TO_DIR = {
	Vector2i(1, 0): 0,
	Vector2i(0, 1): 1,
	Vector2i(-1, 1): 2,
	Vector2i(-1, 0): 3,
	Vector2i(-1, -1): 4,
	Vector2i(0, -1): 5
}

var prev_hovered
var next_hovered
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	prev_hovered = next_hovered
	next_hovered = _get_hovered()
	if !get_node("../../")._get_mouse_on_gui():
		if _mode() == Tools.NewHex && _hex_path() == ["Basic", "Stream"]:
			if Input.is_action_pressed("stream_draw"):
				if next_hovered != prev_hovered:
					_set_selected(next_hovered)
					var offset = next_hovered - prev_hovered
					if abs(prev_hovered.y) % 2 == 1 && prev_hovered.y != next_hovered.y:
						offset -= Vector2i(1, 0)
					var h = hex_scenes._scenes(hex_ids.Stream)
					if offset in TRANSITION_TO_DIR:
						var hex = h.instantiate()
						hex.direction = TRANSITION_TO_DIR[offset]
						hex.location = prev_hovered
						hex._configure()
						_place_hex(hex, prev_hovered)
						_update_edit_handles(prev_hovered)
						
		elif _mode() == Tools.NewHex && _hex_path() == ["Erase"]:
			if Input.is_action_pressed("eraser_draw"):
				var slots = get_node("../../../Tiles")._delete_tile(_get_hovered())
				for s in slots:
					if s != null:
						s.get_parent().remove_child(s)
				_update_edit_handles(prev_hovered)
				slots = []
		elif _mode() == Tools.NewHex:
			if Input.is_action_just_pressed("place_tile"):
				var prev_tile = _get_tile(_get_hovered())
				if prev_tile == null || !_id_is_path(prev_tile._get_id(), _hex_path()):
					var h = _hex_scene()
					var hex = h.instantiate()
					hex.location = _get_hovered()
					hex._configure()
					_place_hex(hex, hex.location)
					_update_edit_handles(prev_hovered)
			
func _mode():
	return get_node("../EditButtons")._get_mode()

func _hex_path():
	return get_node("../Tree")._selected_path()
	
func _id_is_path(id, path):
	return get_node("../Tree")._id_is_path(id, path)

func _hex_scene():
	var hexes = get_node("../Tree")._selected_scene()
	return hexes[0] if hexes is Array else hexes

func _get_selected():
	return get_node("../Coords")._get_selected()
	
func _get_hovered():
	return get_node("../Coords")._get_hovered()
	
func _set_selected(hex):
	return get_node("../Coords")._set_selected(hex)
	
func _place_hex(hex, coords):
	get_node("../../../Tiles")._add_tile(coords, hex)
	
func _update_edit_handles(coords):
	get_node("/root/Control/EditMode/EditHandles")._on_coords_new_hex_hovered(coords)
	
func _get_tile(coords):
	return get_node("../../../Tiles")._get_tile(coords)
	
func _on_tree_cell_selected():
	if _mode() == Tools.Edit:
		if _hex_path() == ["Erase"]:
			get_node("../../../Tiles")._delete_tile(_get_selected())
		else:
			var h = _hex_scene()
			var hex = h.instantiate()
			hex.location = _get_selected()
			hex._configure()
			_place_hex(hex, hex.location)
