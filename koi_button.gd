extends TextureButton

var id = 0

func _set_id(id):
	self.id = id

func _get_id(id):
	return id

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	get_parent()._on_koi_button_press(id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
