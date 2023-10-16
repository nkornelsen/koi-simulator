extends "res://base_hexagon.gd"

func _get_id():
	return preload("res://hexes/hex_ids.gd").Conditional

@export var conditions = [
	"F",
	"F",
	"F",
	"F",
	"F",
	"F"
]

var CENTER_OFFSET = 30.0

@export var direction: RotDirection

var conditions_internal = [];

enum {Greater, Less, GreaterEqual, LessEqual, Equal, True, False}
class Condition:
	var type
	var value
	var enabled
	
	func _init(t, v):
		self.type = t
		self.value = v
		self.enabled = true
	
	func evaluate(other):
		if !enabled:
			return false
		match self.type:
			Greater: return other > self.value
			Less: return other < self.value
			GreaterEqual: return other >= self.value
			LessEqual: return other <= self.value
			Equal: return other == self.value
			True: return true
			False: return false
			_: return false
		
	func _to_string():
		var op;
		match self.type:
			Greater: op = ">"
			Less: op = "<"
			GreaterEqual: op = ">="
			LessEqual: op = "<="
			Equal: op = "="
		if self.type != True && self.type != False:
			return op + str(value)
		else:
			return "T" if self.type == True else "F"


func _ready():
	self._configure()
	
func insert_at_slot(koi, n):
	var i = super.insert_at_slot(koi, n)
	if i >= 0:
		self._set_hex_locked(true)
		self.conditions_internal[n].enabled = false
	return i

func _run_tile():
	var has_koi = false
	for i in 6:
		# can process high and low at same time in this case
		# run condition
		var idx = 2*i+1 if slots[2*i] == null else 2*i
		var koi = slots[idx]
		if koi == null:
			continue
		if conditions_internal[i].evaluate(koi._get_value()) && self._can_send_to(i):
			var s = send_koi(i, i)
			if !s:
				has_koi = true
		else:
			var next_i;
			if direction == RotDirection.CounterClockwise:
				next_i = (i + 1) % 6
			else:
				next_i = (i - 1 + 6) % 6
			insert_at_slot(koi, next_i)
			conditions_internal[next_i].enabled = true
			next_slots[idx] = null
			has_koi = true
	self._set_hex_locked(has_koi || self.next_locked)
	
func _parse_conditions():
	var regex_tf = RegEx.new()
	regex_tf.compile("^([TF])$")
	
	var regex_cmp = RegEx.new()
	regex_cmp.compile("^\\s*(>|<|>=|<=|=)\\s*(\\d+)$")
	
	# parse constant
	for i in 6:
		var result = regex_tf.search(conditions[i])
		if result:
			var type = True if result.get_string(1) == "T" else False
			conditions_internal[i] = Condition.new(type, 0)
			continue
		result = regex_cmp.search(conditions[i])
		if result:
			var type;
			match result.get_string(1):
				">": type = Greater
				"<": type = Less
				">=": type = GreaterEqual
				"<=": type = LessEqual
				"=": type = Equal
			conditions_internal[i] = Condition.new(type, int(result.get_string(2)))

func _update_hex():
	super._update_hex()
	self.next_locked = false
	
func _configure():
	super._configure()
	self.conditions = self.conditions.duplicate()
	conditions_internal = []
	for i in 6:
		conditions_internal.append(Condition.new(False, 0))
	self._parse_conditions()

	# draw labels
	var cond_labels = get_node("CondLabels")
	for c in cond_labels.get_children():
		cond_labels.remove_child(c)
	for i in 6:
		var l = Label.new()
		l.size = Vector2(150.0, 100.0)
		l.text = conditions_internal[i]._to_string()
		l.add_theme_color_override("font_color", Color.BLACK)
		l.pivot_offset = l.size / 2.0
		l.position = Vector2(-75.0, -50.0)
		l.scale = Vector2(0.2, 0.2)
		l.add_theme_font_size_override("font_size", 30)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		l.position += CENTER_OFFSET * Vector2(cos(i*PI/3.0), -sin(i*PI/3.0))
		cond_labels.add_child(l)
	var rotation_dir = get_node("RotationDir")
	if direction == RotDirection.Clockwise:
		rotation_dir.rotation = 0
	else:
		rotation_dir.rotation = PI
		rotation_dir.flip_h = true
		
func _cond_string(i):
	return conditions_internal[i]._to_string()

func _set_cond(i, cond):
	conditions[i] = cond
	_configure()

func _switch_direction():
	if direction == RotDirection.Clockwise:
		direction = RotDirection.CounterClockwise
	else:
		direction = RotDirection.Clockwise
	_configure()

func _get_data():
	var out = str(direction) + " "
	for cond in conditions_internal:
		out += cond._to_string() + " "
	return out

func _read_data(values):
	direction = int(values[0])
	for i in 6:
		conditions[i] = values[i+1]
	
