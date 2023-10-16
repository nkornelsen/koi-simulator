extends "res://hexes/binary_operations/binary_operation.gd"

func _get_id():
	return preload("res://hexes/hex_ids.gd").Sub

func _run_operation(a, b):
	return a - b

func _get_operation():
	return "-"
	
