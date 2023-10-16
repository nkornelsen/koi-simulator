extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_paused(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause") && !get_node("/root/Control/FileOpen").is_visible() && !get_node("/root/Control/FileSave").is_visible():
		self.set_paused(!self.paused)
