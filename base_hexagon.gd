extends Node2D

var slots = []
var next_slots = []
var next_locked = false
@export var location: Vector2i = Vector2i(0, 0)
var tile_manager
var console
var slot_nodes
var hex_locked = false
enum RotDirection { Clockwise, CounterClockwise }
enum SendDirection { Right = 0, UpRight = 1, UpLeft = 2, Left = 3, DownLeft = 4, DownRight = 5}

var DIR_MAP = [
	3,
	4,
	5,
	0,
	1,
	2
]

var OFFSET_MAP = [
	Vector2i(1, 0),
	Vector2i(0, 1),
	Vector2i(-1, 1),
	Vector2i(-1, 0),
	Vector2i(-1, -1),
	Vector2i(0, -1)
]
# Called when the node enters the scene tree for the first time.
func _ready():
	_configure()
	
func _configure():
	if len(slots) != 12:
		slots = []
		next_slots = []
		for i in 12:
			slots.append(null)
			next_slots.append(null)
	# shift to appropriate location
	var y = (-location.y * 100.0 / 115.0) * 100.0
	var x = location.x
	if abs(location.y) % 2 == 1:
		x += 0.5
	x *= 100.0
	self.position = Vector2(x, y)
	slot_nodes = get_node("Slots").get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var y = location.y * 115.0
	#var x = location.x
	#if abs(location.y) % 2 == 1:
	#	x += 0.5
	#x *= 100.0
	#self.position = Vector2(x, y)
	pass
	
func insert_at_slot(koi, n):
	n *= 2
	if slots[n] == null:
		next_slots[n] = koi
		return n
	if slots[n+1] == null:
		next_slots[n+1] = koi
		return n+1
	return -1

func tile_in_direction(dir):
	var o = OFFSET_MAP[dir]
	if o.y != 0 && abs(location.y) % 2 == 1:
		o += Vector2i(1, 0)
	var tile = _tile_manager()._get_tile(location+o)
	return tile
	
func _can_send_to(dir):
	var tile = tile_in_direction(dir)
	if tile == null:
		return false
	var n = DIR_MAP[dir]
	if tile._get_side_open(n) && (tile.slots[2*n] == null || tile.slots[2*n + 1] == null):
		return true
	return false

func send_koi(from_direction, to_direction):
	if !self._can_send_to(to_direction):
		return false
	from_direction *= 2
	var koi = slots[from_direction]
	if koi == null:
		from_direction += 1
		koi = slots[from_direction]
	if koi == null:
		return false
	var tile = tile_in_direction(to_direction)
	if tile == null:
		return false
	if tile._hex_is_locked():
		return false
	
	if tile.insert_at_slot(koi, DIR_MAP[to_direction]) >= 0:
		next_slots[from_direction] = null
		return true
	return false

func _update_hex():
	for i in 12:
		slots[i] = next_slots[i]
		if slots[i] != null && !slots[i]._matches(self, i):
			slots[i]._set_location(self, i)
		slot_nodes[i].get_node("Label").visible = slots[i] == null
	hex_locked = next_locked

func _run_tile():
	pass

# should not be used in regular operation, only initialization
func _set_slot(slot, koi):
	slots[slot] = koi
	next_slots[slot] = koi
	if koi != null:
		slot_nodes[slot].get_node("Label").visible = false
	
func _get_slot(slot):
	return slots[slot]
	
func _get_next_slot(slot):
	return next_slots[slot]

func _set_hex_locked(l):
	next_locked = l

func _hex_is_locked():
	return hex_locked
	
func _get_side_open(i):
	return true
	
func _console():
	return get_node("../../Console/VBoxContainer/Text")
	
func _tile_manager():
	return get_node("..")

func _slots():
	return slots.duplicate()

func _get_id():
	return -1
	
func _get_id_str():
	return preload("res://hexes/hex_ids.gd")._get_id_str(_get_id())

func _get_data():
	return ""
	
func _read_data(values):
	print("Unimplemented: ")
	print(values)

func _get_line():
	return str(location.x) + " " + str(location.y) + " " + _get_id_str() + " " + _get_data()

func _get_location():
	return location

func _set_location(l):
	self.location = l
