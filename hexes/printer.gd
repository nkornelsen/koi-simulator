extends "res://base_hexagon.gd"

func _get_id():
	return preload("res://hexes/hex_ids.gd").Printer

func _run_tile():
	# high
	var con = _console()
	for i in 6:
		if slots[2*i] != null:
			var c = char(slots[2*i]._get_value() & 0xff)
			var s = send_koi(i, DIR_MAP[i])
			if s:
				con.set_text(con.text + str(c))
				return
	for i in 6:
		if slots[2*i + 1] != null:
			var c = char(slots[2*i + 1]._get_value() & 0xff)
			var s = send_koi(i, DIR_MAP[i])
			if s:
				con.set_text(con.text + str(c))
				return
			
