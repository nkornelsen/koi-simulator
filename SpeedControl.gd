extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("../SpeedDisplay").set_text(str(value) + "x")
	get_node("../../../Timer").set_wait_time(1.0 / value)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_value_changed(value):
	get_node("../SpeedDisplay").set_text(str(value) + "x")
	get_node("../../../Timer").start(1.0 / value)

var mouse_over = false
func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false

func _mouse_over():
	return mouse_over
