@tool
extends Node

var configured = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !configured:
		self._do_configure()
	else:
		print("Configuration done")

func _do_configure():
	var tiles = get_node("../Tiles")
	print(tiles.get_children())
	for tile in tiles.get_children():
		#print(tile.get_method_list())
		tile._configure()
		
	
