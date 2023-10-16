extends Control
enum KoiMode { Edit, Execute }
var mode: KoiMode = KoiMode.Edit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("mode_switch"):
		match mode:
			KoiMode.Edit: _enter_execute_mode()
			KoiMode.Execute: _enter_edit_mode()

func _enter_edit_mode():
	var n = get_node("EditMode")
	n._enter()
	mode = KoiMode.Edit

func _exit_edit_mode():
	var n = get_node("EditMode")
	n._exit()

func _enter_execute_mode():
	_exit_edit_mode()
	mode = KoiMode.Execute
