extends "res://base_hexagon.gd"

@export var direction: RotDirection = RotDirection.CounterClockwise
@export var in_a: SendDirection = SendDirection.Left
@export var in_b: SendDirection = SendDirection.Right

func _ready():
	self._configure()
	
func _send_direction_from(i):
	if direction == RotDirection.CounterClockwise:
		return (i + 2) % 6
	else:
		return (i + 6 - 2) % 6
		
		
func _configure():
	super._configure()
	var CENTER_OFFSET = 35.0
	get_node("OpLabel").text = "A" + self._get_operation() + "B"
	var flip = true if direction == RotDirection.Clockwise else false
	for indicator in get_node("DirectionIndicators").get_children():
		indicator.flip_v = flip
		if indicator.name == "A":
			indicator.rotation = -float(in_a)*PI/3.0
		else:
			indicator.rotation = -float(in_b)*PI/3.0
	var off_base = Vector2(-20.0, -36.0)
	get_node("InputLabels/A").position = off_base + CENTER_OFFSET * Vector2(cos(-float(in_a)*PI/3.0), sin(-float(in_a)*PI/3.0))
	get_node("InputLabels/B").position = off_base + CENTER_OFFSET * Vector2(cos(-float(in_b)*PI/3.0), sin(-float(in_b)*PI/3.0))
	
func _run_tile():
	
	if slots[2*in_a] != null &&  \
		slots[2*in_b] != null &&  \
		self._can_send_to(_send_direction_from(in_a)) && \
		self._can_send_to(_send_direction_from(in_b)):
		var result = self._run_operation(slots[2*in_a]._get_value(), slots[2*in_b]._get_value())
		slots[2*in_a]._set_value(result)
		slots[2*in_b]._set_value(result)
		self.send_koi(in_a, _send_direction_from(in_a))
		self.send_koi(in_b, _send_direction_from(in_b))
		if slots[2*in_a+1] != null:
			next_slots[2*in_a] = slots[2*in_a+1]
			next_slots[2*in_a+1] = null
		if slots[2*in_b+1] != null:
			next_slots[2*in_b] = slots[2*in_b+1]
			next_slots[2*in_b+1] = null

func _get_side_open(i):
	if in_a == in_b:
		return false
	return (i == in_a || i == in_b)

func _run_operation(a, b):
	return 0

func _get_operation():
	return "BINOP"
	
func _get_name_a():
	return "A"
	
func _get_name_b():
	return "B"

func _get_in_a():
	return in_a
	
func _get_in_b():
	return in_b
	
func _set_in_a(a):
	in_a = a

func _set_in_b(b):
	in_b = b

func _switch_direction():
	if direction == RotDirection.Clockwise:
		direction = RotDirection.CounterClockwise
	else:
		direction = RotDirection.Clockwise
	_configure()

func _get_data():
	var out = ""
	out += str(in_a) + " "
	out += str(in_b) + " "
	out += str(direction)
	return out

func _read_data(values):
	in_a = int(values[0])
	in_b = int(values[1])
	direction = int(values[2])
