extends Button

var normal_resource = preload("res://Overlays/edge_handle.png")
var active_resource = preload("res://Overlays/edge_handle_active.png")

var has_mouse = false
var id = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	button_down.connect(_on_button_down)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	hidden.connect(_on_mouse_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_down():
	get_parent().get_parent()._set_handle_start(id)
	
func _set_id(id):
	self.id = id
	
func _on_mouse_entered():
	has_mouse = true
	
func _on_mouse_exited():
	has_mouse = false

func _has_mouse():
	return has_mouse

func _set_active():
	icon = active_resource

func _set_inactive():
	icon = normal_resource
