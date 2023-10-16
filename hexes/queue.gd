extends "res://base_hexagon.gd"

func _get_id():
	return preload("res://hexes/hex_ids.gd").Queue

@export var in_push: SendDirection = SendDirection.Right
@export var in_pop: SendDirection = SendDirection.Left
@export var in_peek: SendDirection = SendDirection.UpLeft
var contents: Array[int] = []

func _ready():
	self._configure()
	
func _send_direction_from(i):
		return (i + 1) % 6
		
func _send_direction_err(i):
		return (i + 6 - 1) % 6
		
func _configure():
	super._configure()
	var CENTER_OFFSET = 30.0
	var off_base = Vector2(-75.0, -36.0)
	get_node("InputLabels/Push").position = off_base + CENTER_OFFSET * Vector2(cos(-float(in_push)*PI/3.0), sin(-float(in_push)*PI/3.0))
	get_node("InputLabels/Pop").position = off_base + CENTER_OFFSET * Vector2(cos(-float(in_pop)*PI/3.0), sin(-float(in_pop)*PI/3.0))
	get_node("InputLabels/Peek").position = off_base + CENTER_OFFSET * Vector2(cos(-float(in_peek)*PI/3.0), sin(-float(in_peek)*PI/3.0))
	get_node("PopSuccess").rotation = -in_pop * PI / 3.0
	get_node("PopError").rotation = -in_pop * PI / 3.0
	get_node("PeekSuccess").rotation = -in_peek * PI / 3.0
	get_node("PeekError").rotation = -in_peek * PI / 3.0
	get_node("PushPath").rotation = -in_push * PI / 3.0
	
func _run_tile():
	# pop & peek before push to maintain order
	if slots[2*in_peek] != null:
		var out_value = slots[2*in_peek]._get_value()
		if len(contents) > 0:
			out_value = contents[0]
		var dst_side = _send_direction_from(in_peek) if len(contents) > 0 else _send_direction_err(in_peek)
		if self._can_send_to(dst_side):
			slots[2*in_peek]._set_value(out_value)
			self.send_koi(in_peek, dst_side)
			if slots[2*in_peek+1] != null:
				next_slots[2*in_peek] = slots[2*in_peek+1]
				next_slots[2*in_peek+1] = null
	
	# pop
	if slots[2*in_pop] != null:
		var out_value = slots[2*in_pop]._get_value()
		if len(contents) > 0:
			out_value = contents[0]
		var dst_side = _send_direction_from(in_pop) if len(contents) > 0 else _send_direction_err(in_pop)
		if self._can_send_to(dst_side):
			slots[2*in_pop]._set_value(out_value)
			if len(contents) > 0:
				contents.remove_at(0)
			self.send_koi(in_pop, dst_side)
			if slots[2*in_pop+1] != null:
				next_slots[2*in_pop] = slots[2*in_pop+1]
				next_slots[2*in_pop+1] = null
	
	# push
	if slots[2*in_push] != null:
		var dst_side = _send_direction_from(in_push)
		if self._can_send_to(dst_side):
			contents.append(slots[2*in_push]._get_value())
			self.send_koi(in_push, dst_side)
			if slots[2*in_push+1] != null:
				next_slots[2*in_push] = slots[2*in_push+1]
				next_slots[2*in_push+1] = null

func _get_side_open(i):
	if in_push == in_pop || in_push == in_peek || in_pop == in_peek:
		return false
	return (i == in_push || i == in_pop || i == in_peek)

func _get_in_peek():
	return in_peek
func _get_in_pop():
	return in_pop
func _get_in_push():
	return in_push
func _set_in_peek(in_peek):
	self.in_peek = in_peek
func _set_in_pop(in_pop):
	self.in_pop = in_pop
func _set_in_push(in_push):
	self.in_push = in_push
	
func _get_data():
	return str(in_push) + " " + str(in_pop) + " " + str(in_peek)


func _read_data(values):
	self.in_push = int(values[0])
	self.in_pop = int(values[1])
	self.in_peek = int(values[2])
