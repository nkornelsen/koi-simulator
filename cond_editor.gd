extends LineEdit

var id = 0
var pending = false
var resetting = false

func _set_id(id):
	self.id = id
	
func _get_id():
	return self.id
	
func _ready():
	text_submitted.connect(_on_text_submitted)
	focus_exited.connect(_submit_changes)
	hidden.connect(_submit_changes)
	text_changed.connect(_on_text_changed)

func _submit_changes():
	if pending:
		get_parent().get_parent()._set_condition(id)
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
