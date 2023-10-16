extends "res://base_hexagon.gd"

func _get_id():
	return preload("res://hexes/hex_ids.gd").Router

@export var direction: Array[SendDirection] = [
	SendDirection.Right,
	SendDirection.UpRight,
	SendDirection.UpLeft,
	SendDirection.Left,
	SendDirection.DownLeft,
	SendDirection.DownRight
]

var route_self = load("res://Overlays/route_self.png")
var route_off1 = load("res://Overlays/route_off1.png")
var route_off2 = load("res://Overlays/route_off2.png")
var route_off3 = load("res://Overlays/route_off3.png")

var dir_overlays = []

func _ready():
	self._configure()
	
func _run_tile():
	# track where sends have happened
	var sent = [false,false,false,false,false,false]
	# high
	for i in 6:
		if slots[2*i] != null && !sent[direction[i]]:
			sent[direction[i]] = send_koi(i, direction[i])
	# low
	for i in 6:
		if slots[2*i + 1] != null && !sent[direction[i]]:
			sent[direction[i]] = send_koi(i, direction[i])
			
func _configure():
	super._configure()
	self.direction = direction.duplicate()
	dir_overlays = []
	for child in get_node("overlays").get_children():
		get_node("overlays").remove_child(child)
	for i in 6:
		dir_overlays.append(TextureRect.new())
		dir_overlays[i].scale = Vector2(0.2, 0.2)
		dir_overlays[i].pivot_offset = Vector2(250.0, 288.0)
		dir_overlays[i].position = -Vector2(250.0, 288.0)
		dir_overlays[i].mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		get_node("overlays").add_child(dir_overlays[i])
		dir_overlays[i].rotation = -float(i)*PI/3
		if direction[i] == i:
			dir_overlays[i].texture = route_self
		if direction[i] == (i + 1) % 6:
			dir_overlays[i].texture = route_off1
		if direction[i] == (i + 2) % 6:
			dir_overlays[i].texture = route_off2
		if direction[i] == (i + 3) % 6:
			dir_overlays[i].texture = route_off3
		if direction[i] == (i + 4) % 6:
			dir_overlays[i].texture = route_off2
			dir_overlays[i].flip_v = true
		if direction[i] == (i + 5) % 6:
			dir_overlays[i].texture = route_off1
			dir_overlays[i].flip_v = true
		
func _get_direction():
	return direction
	
func _set_direction(direction):
	self.direction = direction
	
func _get_data():
	var out = ""
	for dir in direction:
		out += str(dir) + " "
	return out

func _read_data(values):
	self.direction = direction.duplicate()
	for i in 6:
		self.direction[i] = int(values[i])
