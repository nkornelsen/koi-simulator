extends Control

var active = false
var lines
var counter

func _get_active():
	return active
	
func _set_active(active):
	self.active = active

# Called when the node enters the scene tree for the first time.
func _ready():
	lines = get_node("ScrollContainer/Lines")
	counter = get_node("Header/Counter")
	get_node("Header/Plus").pressed.connect(_add_line)
	get_node("Header/Minus").pressed.connect(_remove_line)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _fill_contents(c):
	for child in lines.get_children():
		lines.remove_child(child)
	
	for value in c:
		var line = LineEdit.new()
		line.set_text(str(value))
		line.set_mouse_filter(MOUSE_FILTER_PASS)
		lines.add_child(line)
	_update_counter()
	
func _add_line():
	var line = LineEdit.new()
	line.set_text("0")
	line.set_mouse_filter(MOUSE_FILTER_PASS)
	lines.add_child(line)
	_update_counter()
	
	
func _remove_line():
	var children = lines.get_children()
	if len(children) > 0:
		lines.remove_child(children[-1])
		_update_counter()
		children[-1].queue_free()

func _update_counter():
	counter.set_text(str(len(lines.get_children())) + " items")

func _get_contents() -> Array[int]:
	var contents: Array[int] = []
	for child in lines.get_children():
		if child.get_text().is_valid_int():
			contents.append(int(child.get_text()))
		else:
			contents.append(0)
	return contents
