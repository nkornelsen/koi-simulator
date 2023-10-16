extends "res://base_hexagon.gd"

@export var operand = 0

func _ready():
	self._configure()
	
# Called when the node enters the scene tree for the first time.
func _send_direction_from(i):
		return (i + 3) % 6

func _run_tile():
		# track where sends have happened
	var sent = [false,false,false,false,false,false]
	# high
	for i in 6:
		var d = _send_direction_from(i)
		if slots[2*i] != null && !sent[d] && self._can_send_to(d):
			slots[2*i]._set_value(self._run_operation(slots[2*i]._get_value()))
			sent[d] = send_koi(i, d)
	# low
	for i in 6:
		var d = _send_direction_from(i)
		if slots[2*i+1] != null && !sent[d] && self._can_send_to(d):
			slots[2*i+1]._set_value(self._run_operation(slots[2*i+1]._get_value()))
			sent[d] = send_koi(i, d)
			
func _configure():
	super._configure()
	get_node("OpLabel").text = self._get_operation()
		

func _get_operation():
	return "IOP"

func _run_operation(value):
	return 0

func _set_operand(operand):
	self.operand = operand

func _get_operand():
	return operand

func _get_data():
	return str(operand)

func _read_data(values):
	operand = int(values[0])
