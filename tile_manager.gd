extends Node

var updating_tiles = false
var tiles = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		var c = child.name.split("_")
		var l = Vector2i(int(c[0]), int(c[1]))
		child.location = l
		tiles[l] = child
		
	var koi_list = get_node("../Koi")
	for child in koi_list.get_children():
		var c = child.name.split("_")
		var hi_low = 0 if c[3] == "H" else 1
		var t = tiles[Vector2i(int(c[0]), int(c[1]))]
		var s = 2*int(c[2]) + hi_low
		t._set_slot(s, child)
		child._set_location(t, s)
	
	var timer = get_node("../Timer")
	timer.connect("timeout", _on_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _get_tile(coord):
	if coord in tiles:
		return tiles[coord]
	return null

func _on_timer_timeout():
	if updating_tiles:
		return
	updating_tiles = true
	
	for tile in tiles.values():
		tile._run_tile()
	
	for tile in tiles.values():
		tile._update_hex()
	updating_tiles = false

func _delete_tile(coord: Vector2i):
	var slots = [null, null, null, null, null, null, null, null, null, null, null, null]
	if coord in tiles:
		slots = tiles[coord]._slots()
		remove_child(tiles[coord])
		tiles.erase(coord)
	return slots
		
func _add_tile(coord: Vector2i, tile):
	var slots = _delete_tile(coord)
	add_child(tile)
	tiles[coord] = tile
	for i in 12:
		tile._set_slot(i, slots[i])
	for s in slots:
		if s != null:
			s._set_location(tile, s._get_location())

func _clear_board():
	for tile in get_children():
		for s in 12:
			var k = tile._get_slot(s)
			if k != null:
				get_node("/root/Control/Koi").remove_child(k)
				k.queue_free()
			tile._set_slot(s, null)
		
		tiles.erase(tile._get_location())
		tile.queue_free()
	for k in get_node("/root/Control/Koi").get_children():
		k.get_parent().remove_child(k)
		k.queue_free()
