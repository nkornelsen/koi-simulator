enum {
	Stream,
	Conditional,
	Memory,
	Printer,
	Queue,
	Stack,
	Router,
	Splitter,
	Add,
	Mul,
	AND,
	Div,
	OR,
	SL,
	SR,
	Sub,
	XOR,
	AddI,
	ANDI,
	DivI,
	MulI,
	ORI,
	SetI,
	SLI,
	SRI,
	SubI,
	XORI
}

static var id_strings = {
	Stream: "str",
	Conditional: "cond",
	Memory: "mem",
	Printer: "print",
	Queue: "queue",
	Stack: "stack",
	Router: "router",
	Splitter: "split",
	Add: "add",
	Mul: "mul",
	AND: "and",
	Div: "div",
	OR: "or",
	SL: "sl",
	SR: "sr",
	Sub: "sub",
	XOR: "xor",
	AddI: "addi",
	ANDI: "andi",
	DivI: "divi",
	MulI: "muli",
	ORI: "ori",
	SetI: "seti",
	SLI: "sli",
	SRI: "sri",
	SubI: "subi",
	XORI: "xori"
}

static var string_ids = {
	"str": Stream,
	"cond": Conditional,
	"mem": Memory,
	"print": Printer,
	"queue": Queue,
	"stack": Stack,
	"router": Router,
	"add": Add,
	"mul": Mul,
	"and": AND,
	"div": Div,
	"or": OR,
	"sl": SL,
	"sr": SR,
	"sub": Sub,
	"xor": XOR,
	"addi": AddI,
	"andi": ANDI,
	"divi": DivI,
	"muli": MulI,
	"ori": ORI,
	"seti": SetI,
	"sli": SLI,
	"sri": SRI,
	"subi": SubI,
	"xori": XORI,
	"split": Splitter
}

static func _get_id_str(id):
	return id_strings[id]

static func _get_str_id(s):
	return string_ids[s]
