extends LineEdit

var pending = false
var resetting = false
signal new_constant(value)

func _ready():
	text_submitted.connect(_on_text_submitted)
	focus_exited.connect(_submit_changes)
	hidden.connect(_submit_changes)
	text_changed.connect(_on_text_changed)

func _submit_changes():
	if pending:
		new_constant.emit(get_text())
		pending = false

func _on_text_submitted(new_text):
	_submit_changes()

func _on_text_changed(new_text):
	if !resetting:
		pending = true
	else:
		resetting = false
	
	
func _reset_box(text):
	resetting = true
	set_text(text)
