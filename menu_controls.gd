extends CanvasLayer

var save_path = ""
var tile_manager
var Koi = preload("res://koi.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	tile_manager = get_node("/root/Control/Tiles")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("save_file"):
		if save_path == "":
			get_node("../FileSave").set_visible(true)
		else:
			_on_file_save_selected(save_path)

func _on_file_open_selected(path):
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return
	save_path = path
	tile_manager._clear_board()
	var line = file.get_line()
	var position = 0
	var next_position = file.get_position()
	while position != next_position:
		
		# parse line
		var split_whitespace = RegEx.new()
		split_whitespace.compile("\\S+")
		var results = []
		for result in split_whitespace.search_all(line):
			results.push_back(result.get_string())
		if len(results) == 0:
			continue
		
		var location = Vector2i(int(results[0]), int(results[1]))
		if results[2] == "koi":
			var koi = Koi.instantiate()
			koi._set_value(int(results[4]))
			print("Koi at " + str(location))
			koi._set_location(tile_manager._get_tile(location), int(results[3]))
			tile_manager._get_tile(location)._set_slot(int(results[3]), koi)
			get_node("/root/Control/Koi").add_child(koi)
		else:
			var type = preload("res://hexes/hex_ids.gd")._get_str_id(results[2])
			var data = results.slice(3)
			var h_class = preload("res://hexes/hex_scenes.gd")._scenes(type)
			var hex = h_class.instantiate()
			hex._read_data(data)
			hex._set_location(location)
			hex._configure()
			tile_manager._add_tile(location, hex)
			print("Added tile " + str(location))
		
		line = file.get_line()
		position = next_position
		next_position = file.get_position()

func _on_file_button_press(button_id):
	if button_id == 0:
		get_node("../FileOpen").set_visible(true)
	elif button_id == 1:
		if save_path == "":
			get_node("../FileSave").set_visible(true)
		else:
			_on_file_save_selected(save_path)
	elif button_id == 2:
		get_node("../FileSave").set_visible(true)

func _get_tiles():
	return get_node("/root/Control/Tiles").get_children()

func _on_file_save_selected(path):
	save_path = path
	# open file
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		return
	for tile in _get_tiles():
		file.store_line(tile._get_line())
		for s in 12:
			var k = tile._get_slot(s)
			if k != null:
				file.store_line(k._get_line())
	file.close()
	
