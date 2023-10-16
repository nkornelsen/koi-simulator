extends Control

var mouse_on_gui = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_mouse_on_gui(v):
	mouse_on_gui = v
	
func _get_mouse_on_gui():
	return get_node("CanvasLayer/Tree")._mouse_on_tree() || \
		get_node("CanvasLayer/EditButtons")._mouse_over_button() || \
		get_node("CanvasLayer/SpeedControl")._mouse_over() || \
		get_node("EditHandles/MemoryEditList/Controller/Header/Minus").is_hovered() || \
		get_node("EditHandles/MemoryEditList/Controller/Header/Plus").is_hovered() || \
		get_node("EditHandles/MemoryEditList/Controller/ScrollContainer")._get_mouse_over() || \
		get_node("CanvasLayer/KoiValue/Input")._has_mouse()

func _enter():
	get_node("CanvasLayer").set_visible(true)

	get_node("CanvasLayer/Coords").set_process_input(true)
	get_node("SelectionOverlay").set_visible(true)
	if get_node("CanvasLayer/EditButtons")._get_mode() != 2:
		get_node("EditHandles").set_visible(true)
		get_node("CanvasLayer/KoiValue").set_visible(false)
		get_node("KoiHandles").set_visible(false)
	else:
		get_node("CanvasLayer/KoiValue").set_visible(true)
		get_node("KoiHandles").set_visible(true)
	set_process(true)

func _exit():
	get_node("CanvasLayer").set_visible(false)

	get_node("CanvasLayer/Coords").set_process_input(false)
	get_node("SelectionOverlay").set_visible(false)
	get_node("EditHandles").set_visible(false)
	get_node("CanvasLayer/KoiValue").set_visible(false)
	get_node("KoiHandles").set_visible(false)
	set_process(false)
