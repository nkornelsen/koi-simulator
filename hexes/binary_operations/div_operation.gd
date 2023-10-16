extends "res://hexes/binary_operations/binary_operation.gd"

func _get_id():
	return preload("res://hexes/hex_ids.gd").Div

func _run_operation(a, b):
	#warning-ignore:integer_division
	return a / b

func _get_operation():
	return "/"
	
