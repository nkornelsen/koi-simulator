extends Tree

var selecting = false
enum Tools { NewHex=0, Edit=1, AddKoi=2 }
signal user_cell_selected

class DisplayElement:
	var hexes
	var treeitem
	func _init(treeitem, hexes):
		self.treeitem = treeitem
		self.hexes = hexes

var hex_ids = preload("res://hexes/hex_ids.gd")
var hex_scenes = preload("res://hexes/hex_scenes.gd")

var HEX_TREE = {
	"Erase": -1,
	"Basic": {
		"Stream": hex_ids.Stream,
		"Printer": hex_ids.Printer,
		"Router": hex_ids.Router,
		"Conditional": hex_ids.Conditional,
		"Splitter": hex_ids.Splitter
	},
	"Memory": {
		"Vector": hex_ids.Memory,
		"Stack": hex_ids.Stack,
		"Queue": hex_ids.Queue
	},
	"Math": {
		"Add": hex_ids.Add,
		"Subtract": hex_ids.Sub,
		"Multiply": hex_ids.Mul,
		"Divide": hex_ids.Div
	},
	"Bitwise": {
		"AND": hex_ids.AND,
		"OR": hex_ids.OR,
		"XOR": hex_ids.XOR,
		"Shift Left": hex_ids.SL,
		"Shift Right": hex_ids.SR
	},
	"Constant Ops": {
		"Set Constant": hex_ids.SetI,
		"Add": hex_ids.AddI,
		"Subtract": hex_ids.SubI,
		"Multiply": hex_ids.MulI,
		"Divide": hex_ids.DivI,
		"AND": hex_ids.ANDI,
		"OR": hex_ids.ORI,
		"XOR": hex_ids.XORI,
		"Shift Left": hex_ids.SLI,
		"Shift Right": hex_ids.SRI
	}
}

var display_tree = {}
var id_to_path = {}

var has_mouse = false

# Called when the node enters the scene tree for the first time.
func _ready():
	selecting = true
	var root = create_item()
	set_hide_root(true)
	initialize_tree_recursive(HEX_TREE, root, display_tree, [])
	set_process_input(true)
	_select_item(display_tree["Basic"]["Stream"].treeitem)
	selecting = false

func initialize_tree_recursive(tree, parent, display, path):
	for key in tree:
		var item = create_item(parent)
		item.set_text(0, key)
		var p = path.duplicate()
		p.append(key)
		if tree[key] is Dictionary:
			display[key] = {}
			item.set_selectable(0, false)
			initialize_tree_recursive(tree[key], item, display[key], p)
			item.set_collapsed(true)
		else:
			display[key] = DisplayElement.new(item, tree[key][0] if tree[key] is Array else tree[key])
			if tree[key] is Array:
				for t in tree[key]:
					id_to_path[t] = p
			elif key != "Erase":
				id_to_path[tree[key]] = p
			item.set_selectable(0, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mouse_entered():
	has_mouse = true

func _on_mouse_exited():
	has_mouse = false
	
func _mouse_on_tree():
	return has_mouse
	
func _select_item(treeitem):
	selecting = true
	var p = treeitem.get_parent()
	while p:
		p.set_collapsed(false)
		p = p.get_parent()

	set_selected(treeitem, 0)
	
func _on_cell_selected():
	if selecting:
		selecting = false
	else:
		user_cell_selected.emit()

func _on_item_collapsed(item):
	if !selecting && !item.is_collapsed():
		var par = get_selected().get_parent()
		while par:
			if par == item:
				_select_item(get_selected())
				return
			else:
				par = par.get_parent()

func _selected_path():
	var path = []
	var p = get_selected()
	while p != get_root():
		path.push_front(p.get_text(0))
		p = p.get_parent()
	return path
	
func _selected_scene():
	var path = _selected_path()
	var i = 0
	var t = HEX_TREE
	while t is Dictionary:
		t = t[path[i]]
		i += 1
	return hex_scenes._scenes(t[0] if t is Array else t)
	
func _id_is_path(id, path):
	return id_to_path[id] == path

func _item_from_path(path):
	var i = 0
	var t = display_tree
	while t is Dictionary:
		t = t[path[i]]
		i += 1
	return t.treeitem

func _on_coords_new_hex_selected():
	var tile_manager = get_node("/root/Control/Tiles")
	var coord = get_node("/root/Control/EditMode/CanvasLayer/Coords")._get_selected()
	if get_node("/root/Control/EditMode/CanvasLayer/EditButtons")._get_mode() == Tools.Edit:
		var t = tile_manager._get_tile(coord)
		if t != null:
			# select that tile
			var ti = _item_from_path(id_to_path[t._get_id()])
			_select_item(ti)
			scroll_to_item(ti)
			queue_redraw()
