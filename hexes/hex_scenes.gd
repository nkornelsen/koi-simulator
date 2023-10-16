static var hex_ids = preload("res://hexes/hex_ids.gd")

static var Scenes = {
	hex_ids.Stream: preload("res://hexes/stream.tscn"),
	hex_ids.Conditional: preload("res://hexes/conditional.tscn"),
	hex_ids.Memory: preload("res://hexes/memory.tscn"),
	hex_ids.Printer: preload("res://hexes/printer.tscn"),
	hex_ids.Queue: preload("res://hexes/queue.tscn"),
	hex_ids.Stack: preload("res://hexes/stack.tscn"),
	hex_ids.Router: preload("res://hexes/router.tscn"),
	hex_ids.Splitter: preload("res://hexes/splitter.tscn"),
	hex_ids.Add: preload("res://hexes/n_ary_operations/add_operation.tscn"),
	hex_ids.Mul: preload("res://hexes/n_ary_operations/mul_operation.tscn"),
	hex_ids.AND: preload("res://hexes/binary_operations/and_operation.tscn"),
	hex_ids.Div: preload("res://hexes/binary_operations/div_operation.tscn"),
	hex_ids.OR: preload("res://hexes/binary_operations/or_operation.tscn"),
	hex_ids.SL: preload("res://hexes/binary_operations/sl_operation.tscn"),
	hex_ids.SR: preload("res://hexes/binary_operations/sr_operation.tscn"),
	hex_ids.Sub: preload("res://hexes/binary_operations/sub_operation.tscn"),
	hex_ids.XOR: preload("res://hexes/binary_operations/xor_operation.tscn"),
	hex_ids.AddI: preload("res://hexes/i_operations/add_i_operation.tscn"),
	hex_ids.ANDI: preload("res://hexes/i_operations/and_i_operation.tscn"),
	hex_ids.DivI: preload("res://hexes/i_operations/div_i_operation.tscn"),
	hex_ids.MulI: preload("res://hexes/i_operations/mul_i_operation.tscn"),
	hex_ids.ORI: preload("res://hexes/i_operations/or_i_operation.tscn"),
	hex_ids.SetI: preload("res://hexes/i_operations/set_operation.tscn"),
	hex_ids.SLI: preload("res://hexes/i_operations/sl_i_operation.tscn"),
	hex_ids.SRI: preload("res://hexes/i_operations/sr_i_operation.tscn"),
	hex_ids.SubI: preload("res://hexes/i_operations/sub_i_operation.tscn"),
	hex_ids.XORI: preload("res://hexes/i_operations/xor_i_operation.tscn")
}

static func _scenes(i):
	return Scenes[i]
