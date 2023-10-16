extends "res://base_hexagon.gd"

@export var direction: RotDirection = RotDirection.CounterClockwise

func _ready():
	self._configure()
	
# Called when the node enters the scene tree for the first time.
func _send_direction_from(i):
	if direction == RotDirection.CounterClockwise:
		return (i + 2) % 6
	else:
		return (i + 6 - 2) % 6

func _run_tile():
	var values = []
	for i in 6:
		if slots[2*i] != null:
			values.append(slots[2*i]._get_value())
			if !self._can_send_to(_send_direction_from(i)):
				return
	if len(values) == 0:
		# attempt promotion
		for i in 6:
			if slots[2*i+1] != null:
				next_slots[2*i] = slots[2*i+1]
				next_slots[2*i+1] = null
	if len(values) < 2:
		return
	var result = self._run_operation(values)
	for i in 6:
		if slots[2*i] != null:
			slots[2*i]._set_value(result)
			self.send_koi(i, _send_direction_from(i))
			if slots[2*i+1] != null:
				next_slots[2*i] = slots[2*i+1]
				next_slots[2*i+1] = null
			
func _configure():
	super._configure()
	get_node("OpLabel").text = self._get_operation()
	var flip = true if direction == RotDirection.Clockwise else false
	for indicator in get_node("DirectionIndicators").get_children():
		indicator.flip_v = flip
		

func _get_operation():
	return "NARYOP"

func _run_operation(values):
	return 0

func _get_direction():
	return direction
	
func _set_direction(direction):
	self.direction = direction
	
func _switch_direction():
	if direction == RotDirection.Clockwise:
		direction = RotDirection.CounterClockwise
	else:
		direction = RotDirection.Clockwise
	_configure()

func _get_data():
	return str(direction)

func _read_data(values):
	direction = int(values[0])
