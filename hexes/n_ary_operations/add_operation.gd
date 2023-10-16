extends "res://hexes/n_ary_operations/n_ary_operation.gd"

func _get_id():
	return preload("res://hexes/hex_ids.gd").Add

func _get_operation():
	return "+"

func _run_operation(values):
	var a = 0
	for v in values:
		a += v
	return a
