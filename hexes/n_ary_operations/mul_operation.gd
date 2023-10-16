extends "res://hexes/n_ary_operations/n_ary_operation.gd"

func _get_id():
	return preload("res://hexes/hex_ids.gd").Mul

func _get_operation():
	return "*"

func _run_operation(values):
	var a = values[0]
	for i in range(1, len(values)):
		a *= values[i]
	return a
