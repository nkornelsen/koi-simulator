extends Node2D

static var hex_ids = preload("res://hexes/hex_ids.gd")
const NaryExpression = preload("res://hexes/n_ary_operations/n_ary_operation.gd")
const BinaryExpression = preload("res://hexes/binary_operations/binary_operation.gd")
const IOperation = preload("res://hexes/i_operations/i_operation.gd")
var coords = Vector2i(0, 0)

var handle_start = -1
var grab_buttons;
var cond_edits
var rot_switch
var mem_editor

var editing_tile
# Called when the node enters the scene tree for the first time.
func _ready():
	grab_buttons = get_node("Grabs").get_children()
	cond_edits = get_node("CondEdits").get_children()
	rot_switch = get_node("RotationSwitch")
	mem_editor = get_node("MemoryEditList/Controller")
	get_node("Grabs").set_visible(false)
	get_node("CondEdits").set_visible(false)
	get_node("EditButton").set_visible(false)
	get_node("ConstInput").set_visible(false)
	mem_editor.set_visible(false)
	rot_switch.set_visible(false)
	for i in 6:
		grab_buttons[i]._set_id(i)
		cond_edits[i]._set_id(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mem_editor._get_active() && Input.is_action_just_pressed("vector_edit_confirm"):
		var t = _get_tile()
		if t._get_id() == hex_ids.Memory:
			t._set_contents(mem_editor._get_contents())
			t._configure()
		mem_editor._set_active(false)
		mem_editor.set_visible(false)
	if Input.is_action_just_released("grab_handle_interact") && handle_start != -1:	
		var t = _get_tile()
		if t != null:
			if t._get_id() == hex_ids.Router:
				get_node("Grabs").set_visible(true)
				var handle_end = -1
				for i in 6:
					if grab_buttons[i]._has_mouse():
						handle_end = i
						break
				if handle_end != -1:
					var directions = t._get_direction().duplicate()
					directions[handle_start] = handle_end
					t._set_direction(directions)
					t._configure()
					
				grab_buttons[handle_start]._set_inactive()
				handle_start = -1
			elif t._get_id() == hex_ids.Memory:
				get_node("Grabs").set_visible(true)
				var handle_end = -1
				for i in 6:
					if grab_buttons[i]._has_mouse():
						handle_end = i
						break
				if handle_end != -1:
					if handle_start == t._get_in_addr():
						t._set_in_addr(handle_end)
					elif handle_start == t._get_in_data():
						t._set_in_data(handle_end)
					elif handle_start == t._get_err_out():
						t._set_err_out(handle_end)
					t._configure()
				grab_buttons[handle_start]._set_inactive()
				handle_start = -1
				for i in 6:
					grab_buttons[i].set_visible(false)
				for i in [t._get_in_addr(), t._get_in_data(), t._get_err_out()]:
					grab_buttons[i].set_visible(true)
			elif t._get_id() == hex_ids.Splitter:
				get_node("Grabs").set_visible(true)
				if t._get_in_side() == handle_start:
					var handle_end = -1
					for i in 6:
						if grab_buttons[i]._has_mouse():
							handle_end = i
							break
					if handle_end != -1:
						t._set_in_side(handle_end)
						t._configure()
				grab_buttons[handle_start]._set_inactive()
				handle_start = -1
			elif t._get_id() == hex_ids.Stack || t._get_id() == hex_ids.Queue:
				get_node("Grabs").set_visible(true)
				var handle_end = -1
				for i in 6:
					if grab_buttons[i]._has_mouse():
						handle_end = i
						break
				if handle_end != -1:
					if handle_start == t._get_in_push():
						t._set_in_push(handle_end)
					elif handle_start == t._get_in_peek():
						t._set_in_peek(handle_end)
					elif handle_start == t._get_in_pop():
						t._set_in_pop(handle_end)
					t._configure()
				grab_buttons[handle_start]._set_inactive()
				handle_start = -1
				for i in 6:
					grab_buttons[i].set_visible(false)
				for i in [t._get_in_peek(), t._get_in_push(), t._get_in_pop()]:
					grab_buttons[i].set_visible(true)
			elif t is BinaryExpression:
				get_node("Grabs").set_visible(true)
				var handle_end = -1
				for i in 6:
					if grab_buttons[i]._has_mouse():
						handle_end = i
						break
				if handle_end != -1:
					if handle_start == t._get_in_a():
						t._set_in_a(handle_end)
					elif handle_start == t._get_in_b():
						t._set_in_b(handle_end)
					t._configure()
				for i in 6:
					grab_buttons[i].set_visible(false)
				for i in [t._get_in_a(), t._get_in_b()]:
					grab_buttons[i].set_visible(true)
				grab_buttons[handle_start]._set_inactive()
				handle_start = -1
			
		handle_start = -1
func idx_to_coord(i):
	var y = float(i.y)
	var x = float(i.x)
	if pingpong(y, 1.0) > 0.5:
		x += 0.5
	return Vector2(x, y*sqrt(3.0)/2.0)

func _on_coords_new_hex_hovered(c):
	if mem_editor._get_active():
		return
	handle_start = -1
	for i in 6:
		grab_buttons[i]._set_inactive()
	coords = c
	var tile_manager = get_node("/root/Control/Tiles")
	self.position = 100.0 * idx_to_coord(c) * Vector2(1.0, -(2.0 / ( 1.15 * sqrt(3.0))))
	var t = tile_manager._get_tile(c)
	for child in get_node("Grabs").get_children():
		child.set_visible(true)
	mem_editor.set_visible(false)
	get_node("Grabs").set_visible(false)
	get_node("CondEdits").set_visible(false)
	get_node("RotationSwitch").set_visible(false)
	get_node("EditButton").set_visible(false)
	get_node("ConstInput").set_visible(false)
	if t != null:
		if t._get_id() == hex_ids.Router:
			get_node("Grabs").set_visible(true)
		if t._get_id() == hex_ids.Conditional:
			get_node("RotationSwitch").set_visible(true)
			get_node("CondEdits").set_visible(true)
			for i in 6:
				cond_edits[i]._reset_box(t._cond_string(i))
		if t._get_id() == hex_ids.Memory:
			var grabs = get_node("Grabs")
			grabs.set_visible(true)
			for grab in grabs.get_children():
				grab.set_visible(false)
			for i in [t._get_in_addr(), t._get_in_data(), t._get_err_out()]:
				grabs.get_children()[i].set_visible(true)
			get_node("EditButton").set_visible(true)
		elif t._get_id() == hex_ids.Splitter:
			get_node("Grabs").set_visible(true)
			get_node("RotationSwitch").set_visible(true)
		elif t._get_id() == hex_ids.Stack || t._get_id() == hex_ids.Queue:
			var grabs = get_node("Grabs")
			grabs.set_visible(true)
			for grab in grabs.get_children():
				grab.set_visible(false)
			for i in [t._get_in_push(), t._get_in_pop(), t._get_in_peek()]:
				grabs.get_children()[i].set_visible(true)
		elif t is NaryExpression:
			get_node("RotationSwitch").set_visible(true)
		elif t is BinaryExpression:
			get_node("RotationSwitch").set_visible(true)
			var grabs = get_node("Grabs")
			grabs.set_visible(true)
			for grab in grabs.get_children():
				grab.set_visible(false)
			for i in [t._get_in_a(), t._get_in_b()]:
				grab_buttons[i].set_visible(true)
		elif t is IOperation:
			get_node("ConstInput").set_visible(true)
			get_node("ConstInput")._reset_box(str(t._get_operand()))

func _get_tile():
	return get_node("/root/Control/Tiles")._get_tile(coords)
	
func _set_handle_start(i):
	handle_start = i
	grab_buttons[i]._set_active()
	var t = _get_tile()
	if t._get_id() == hex_ids.Memory:
		for j in 6:
			grab_buttons[j].set_visible(true)
		for j in [t._get_in_addr(), t._get_in_data(), t._get_err_out()]:
			if j != handle_start:
				grab_buttons[j].set_visible(false)
	elif t._get_id() == hex_ids.Splitter:
		if i != t._get_in_side():
			t._toggle_direction(i)
			t._configure()
	elif t._get_id() == hex_ids.Stack || t._get_id() == hex_ids.Queue:
		for j in 6:
			grab_buttons[j].set_visible(true)
		var blocked_sides = []
		if handle_start == t._get_in_peek():
			blocked_sides.append(t._get_in_pop())
			blocked_sides.append((t._get_in_pop() + 2) % 6)
			blocked_sides.append((t._get_in_pop() - 2 + 6) % 6)
			blocked_sides.append(t._get_in_push())
			blocked_sides.append((t._get_in_push() - 2 + 6) % 6)
		elif handle_start == t._get_in_pop():
			blocked_sides.append(t._get_in_peek())
			blocked_sides.append((t._get_in_peek() + 2) % 6)
			blocked_sides.append((t._get_in_peek() - 2 + 6) % 6)
			blocked_sides.append(t._get_in_push())
			blocked_sides.append((t._get_in_push() - 2 + 6) % 6)
		elif handle_start == t._get_in_push():
			blocked_sides.append(t._get_in_peek())
			blocked_sides.append(t._get_in_pop())
			if t._get_id() == hex_ids.Stack:
				blocked_sides.append((t._get_in_peek() + 2) % 6)
				blocked_sides.append((t._get_in_pop() + 2) % 6)
			else:
				blocked_sides.append((t._get_in_peek() + 4) % 6)
				blocked_sides.append((t._get_in_pop() + 4) % 6)
		for j in blocked_sides:
			if j != handle_start:
				grab_buttons[j].set_visible(false)
	elif t is BinaryExpression:
		for j in 6:
			grab_buttons[j].set_visible(true)
		for j in [t._get_in_a(), t._get_in_b()]:
			if j != handle_start:
				grab_buttons[j].set_visible(false)
			

func _set_condition(i):
	var t = _get_tile()
	if t._get_id() == hex_ids.Conditional:
		t._set_cond(i, cond_edits[i].get_text())

func _swap_rotation():
	var t = _get_tile()
	if t._get_id() == hex_ids.Conditional || t is NaryExpression || t is BinaryExpression || t._get_id() == hex_ids.Splitter:
		t._switch_direction()
	

func _open_memory_editor():
	var t = _get_tile()
	if t._get_id() == hex_ids.Memory:
		editing_tile = t
		mem_editor.set_visible(true)
		mem_editor._set_active(true)
		mem_editor._fill_contents(t._get_contents())

func _on_new_hex_selected():
	if mem_editor._get_active():
		mem_editor._set_active(false)
		
		var t = _get_tile()
		if t._get_id() == hex_ids.Memory:
			t._set_contents(mem_editor._get_contents())
			t._configure()
		_on_coords_new_hex_hovered(get_node("/root/Control/EditMode/CanvasLayer/Coords")._get_hovered())

func _on_new_constant(value):
	var t = _get_tile()
	if t is IOperation:
		var v = int(value) if value.is_valid_int() else t._get_operand()
		t._set_operand(v)
		t._configure()
