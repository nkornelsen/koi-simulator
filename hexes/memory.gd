extends "res://base_hexagon.gd"

func _get_id():
	return preload("res://hexes/hex_ids.gd").Memory

@export var in_addr: SendDirection = SendDirection.Left
@export var in_data: SendDirection = SendDirection.Right
@export var err_out: SendDirection = SendDirection.UpLeft
@export var contents: Array[int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

func _ready():
	self._configure()
	
func _send_direction_from(i):
	return (i + 3) % 6
		
		
func _configure():
	super._configure()
	var CENTER_OFFSET = 30.0
	get_node("SizeLabel").text = self._get_sizelabel()
	var off_base = Vector2(-75.0, -36.0)
	get_node("InputLabels/Addr").position = off_base + CENTER_OFFSET * Vector2(cos(-float(in_addr)*PI/3.0), sin(-float(in_addr)*PI/3.0))
	get_node("InputLabels/Data").position = off_base + CENTER_OFFSET * Vector2(cos(-float(in_data)*PI/3.0), sin(-float(in_data)*PI/3.0))
	get_node("InputLabels/Err").position = off_base + CENTER_OFFSET * Vector2(cos(-float(err_out)*PI/3.0), sin(-float(err_out)*PI/3.0))
	
func _run_tile():
	if slots[2*in_addr] != null:
		if slots[2*in_data] != null:
			# write
			var valid_write = slots[2*in_addr]._get_value() < len(contents)
			var movement = false
			if valid_write && self._can_send_to(_send_direction_from(in_addr)) && self._can_send_to(_send_direction_from(in_data)):
				contents[slots[2*in_addr]._get_value()] = slots[2*in_data]._get_value()
				self.send_koi(in_addr, _send_direction_from(in_addr))
				self.send_koi(in_data, _send_direction_from(in_data))
				movement = true
			if !valid_write && self._can_send_to(err_out) && self._can_send_to(_send_direction_from(in_data)):
				self.send_koi(in_addr, err_out)
				self.send_koi(in_data, _send_direction_from(in_data))
				movement = true
			if movement:
				if slots[2*in_addr+1] != null:
					next_slots[2*in_addr] = slots[2*in_addr+1]
					next_slots[2*in_addr+1] = null
				if slots[2*in_data+1] != null:
					next_slots[2*in_data] = slots[2*in_data+1]
					next_slots[2*in_data+1] = null
		else:
			# read
			var valid_read = slots[2*in_addr]._get_value() < len(contents)
			var m = false
			if valid_read && self._can_send_to(_send_direction_from(in_addr)):
				slots[2*in_addr]._set_value(contents[slots[2*in_addr]._get_value()])
				self.send_koi(in_addr, _send_direction_from(in_addr))
				m = true
			if !valid_read && self._can_send_to(err_out):
				self.send_koi(in_addr, err_out)
				m = true
			if m && slots[2*in_addr+1] != null:
				next_slots[2*in_addr] = slots[2*in_addr+1]
				next_slots[2*in_addr+1] = null

func _get_side_open(i):
	if in_addr == in_data || err_out == _send_direction_from(in_data):
		return false
	return (i == in_addr || i == in_data)

func _get_sizelabel():
	return "[" + str(len(contents)) + "]"

func _get_in_addr():
	return in_addr
	
func _set_in_addr(in_addr):
	self.in_addr = in_addr
	
func _get_in_data():
	return in_data
	
func _set_in_data(in_data):
	self.in_data = in_data
	
func _get_err_out():
	return err_out

func _set_err_out(err_out):
	self.err_out = err_out
	
func _get_contents():
	return contents
	
func _set_contents(contents: Array[int]):
	self.contents = contents

func _get_data():
	var out = ""
	out += str(in_addr) + " "
	out += str(in_data) + " "
	out += str(err_out) + " "
	for val in contents:
		out += str(val) + " "
	return out

func _read_data(values):
	contents = []
	in_addr = int(values[0])
	in_data = int(values[1])
	err_out = int(values[2])
	for val in values.slice(3):
		contents.append(val)
