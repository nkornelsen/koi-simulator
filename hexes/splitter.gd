extends "res://base_hexagon.gd"

func _get_id():
	return preload("res://hexes/hex_ids.gd").Splitter

@export var rot_direction: RotDirection = RotDirection.CounterClockwise
@export var in_side: SendDirection = SendDirection.Left
@export var out_dirs: Array[bool] = [
	true,
	true,
	true,
	true,
	true,
	true
]

func _next_slot_from(i):
	var offset = 1 if rot_direction == RotDirection.CounterClockwise else 5
	for j in 6:
		i = (i + offset) % 6
		if i == in_side:
			return -1
		if out_dirs[i]:
			return i
	return -1
	
func _slot_empty(i):
	return (slots[2*i] == null && slots[2*i+1] == null)

func _run_tile():
	var slot_sent = [false, false, false, false, false, false]
	var ready_to_send = true
	var can_send = true
	# attempt to send
	for i in 6:
		if out_dirs[i] && (slots[2*i] == null && slots[2*i+1] == null):
			ready_to_send = false
			break
			
	if ready_to_send:
		for i in 6:
			if out_dirs[i] && !_can_send_to(i):
				can_send = false
		
		if can_send:
			for i in 6:
				if out_dirs[i]:
					send_koi(i, i)
					slot_sent[i] = true
					
			# shift in_side preemptively
			var next_side = _next_slot_from(in_side)
			if next_side != -1:
				var from_slot = 2*in_side if slots[2*in_side] != null else 2*in_side+1
				if slots[from_slot] != null:
					insert_at_slot(slots[from_slot], next_side)
					next_slots[from_slot] = null
		return
	
	# rotation
	# check koi at input
	if !(slots[2*in_side] != null || slots[2*in_side+1] != null):
		return
	
	# check all sides can rotate
	for i in 6:
		if i == in_side || out_dirs[i]:
			if slots[2*i] == null && slots[2*i+1] == null:
				# skip empty slots
				continue
			var next_side = _next_slot_from(i)
			if next_side == -1 || !(slots[2*next_side] == null || slots[2*next_side+1] == null):
				return
	
	# do rotation
	for i in 6:
		if i == in_side || out_dirs[i]:
			var from_slot = 2*i if slots[2*i] != null else 2*i+1
			if slots[from_slot] == null:
				# skip empty slots
				continue
			
			var to_slot = _next_slot_from(i)
			insert_at_slot(slots[from_slot], to_slot)
			next_slots[from_slot] = null
	
	# promote at input slot
	# we already know (at least) one of H or L is active, if both are active we promote L to H
	# if only H or only L, already rotated out
	if slots[2*in_side] != null && slots[2*in_side+1] != null:
		next_slots[2*in_side] = slots[2*in_side+1]
		next_slots[2*in_side+1] = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self._configure()

func _configure():
	super._configure()
	out_dirs = out_dirs.duplicate()
	var outs = get_node("OutArrows").get_children()
	for i in 6:
		if out_dirs[i] == true:
			outs[i].set_visible(true)
		else:
			outs[i].set_visible(false)
	outs[in_side].set_visible(false)
	get_node("InArrow").set_rotation(-PI * in_side/3.0)
	out_dirs[in_side] = false
	if rot_direction == RotDirection.Clockwise:
		get_node("RotationDir").set_rotation(0)
		get_node("RotationDir").set_flip_v(false)
	else:
		get_node("RotationDir").set_rotation(PI)
		get_node("RotationDir").set_flip_v(true)
		
	
func _get_side_open(i):
	return i == in_side

func _get_in_side():
	return in_side

func _set_in_side(in_side):
	self.in_side = in_side

func _toggle_direction(i):
	self.out_dirs[i] = !self.out_dirs[i]

func _switch_direction():
	if rot_direction == RotDirection.Clockwise:
		rot_direction = RotDirection.CounterClockwise
	else:
		rot_direction = RotDirection.Clockwise
	_configure()

func _process(delta):
	pass

func _get_data():
	var out = str(rot_direction) + " " + str(in_side) + " "
	for i in 6:
		out += "T " if out_dirs[i] else "F "
	return out

func _read_data(values):
	self.rot_direction = int(values[0])
	self.in_side = int(values[1])
	for i in 6:
		self.out_dirs[i] = true if values[i+2] == "T" else false
