@tool
extends TextureRect
var grid_offset = Vector2(0.0, 0.0);
var hex_width = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.material.set_shader_parameter("rect_size", Vector2(1280.0, 720.0));
	set_hex_width(100.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var x = self.get_rect().size[0];
	var y = self.get_rect().size[1];
	self.material.set_shader_parameter("rect_size", Vector2(float(x), float(y)));
	self.material.set_shader_parameter("grid_offset", grid_offset);
	self.material.set_shader_parameter("hex_width", hex_width);

func set_grid_offset(go):
	grid_offset = go

func set_hex_width(w):
	hex_width = w

func get_bg_grid_size():
	return self.get_rect().size
	
func get_bg_hex_width():
	return hex_width

func get_bg_grid_offset():
	return grid_offset
