extends "res://base_hexagon.gd"

func _get_id():
	return preload("res://hexes/hex_ids.gd").Stream

@export var direction: SendDirection = SendDirection.Right


func _ready():
	self._configure()

func _run_tile():
	# high
	for i in 6:
		if slots[2*i] != null:
			var s = send_koi(i, direction)
			if s:
				return
	# low
	for i in 6:
		if slots[2*i + 1] != null:
			var s = send_koi(i, direction)
			if s:
				return

func _configure():
	super._configure()
	get_node("OutArrow").rotation = -float(direction) * PI / 3.0

func _get_data():
	return str(direction)

func _read_data(values):
	direction = int(values[0])
