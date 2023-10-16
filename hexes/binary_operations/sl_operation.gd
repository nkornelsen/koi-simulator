extends "res://hexes/binary_operations/binary_operation.gd"

func _get_id():
	return preload("res://hexes/hex_ids.gd").SL

func _run_operation(a, b):
	return (abs(a) << b) * (1 if a >= 0 else -1)

func _get_operation():
	return "<<"
	
