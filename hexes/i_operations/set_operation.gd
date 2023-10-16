extends "res://hexes/i_operations/i_operation.gd"

func _get_id():
	return preload("res://hexes/hex_ids.gd").SetI

func _get_operation():
	return "=" + str(operand)

func _run_operation(value):
	return operand
