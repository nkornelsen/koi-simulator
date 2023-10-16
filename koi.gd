extends Label

class_name Koi

@export var value = 0
var current_tile;
var current_location;

var CENTER_OFFSET = 30.0
var ANGLES = [
	# 0 HL
	20.0,
	-20.0,
	
	#60 LH
	40.0,
	80.0,
	
	# 120 HL
	140.0,
	100.0,
	
	# 180 LH
	160.0,
	200.0,
	
	# 240 HL
	260.0,
	220.0,
	
	# 300 LH
	280.0,
	320.0
]
# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = ">:" + str(value) + ">"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = ">:" + str(value) + ">"

func _set_location(tile, location):
	current_tile = tile
	current_location = location
	
	self.position = tile.position + CENTER_OFFSET * Vector2(cos(ANGLES[location] * PI / 180.0), -sin(ANGLES[location] * PI / 180.0))

func _matches(tile, location):
	return tile == current_tile && location == current_location
	
func _get_location():
	return current_location
	
func _get_tile():
	return current_tile

func _get_value():
	return self.value

func _set_value(v):
	self.value = v

func _get_line():
	return str(current_tile._get_location().x) + " " + str(current_tile._get_location().y) + " koi " + str(current_location) + " " + str(value)
