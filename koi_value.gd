extends LineEdit

var has_mouse = false
func _has_mouse():
	return has_mouse

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	hidden.connect(_on_mouse_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mouse_entered():
	has_mouse = true

func _on_mouse_exited():
	has_mouse = false
