extends "res://hexes/i_operations/i_operation.gd"

func _get_id():
	return preload("res://hexes/hex_ids.gd").SRI

func _get_operation():
	return ">>" + str(operand)

func _run_operation(value):
	return (abs(value) >> operand) * (1 if value >= 0 else -1)
