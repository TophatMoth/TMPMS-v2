extends Window
class_name FileObject

@export var global_position : Vector2i = Vector2(0, 0):
	set(value):
		global_position = value;
		if get_tree() != null:
			update_local_position();
		else:
			last_local_position = position;

var last_local_position : Vector2i = Vector2i.ZERO;

var being_held : bool = false;

var local_filename : String = "" #EX: Text1.txt, Image1.txt, Folder1/

func _ready():
	# Connect to its own signals
	@warning_ignore(return_value_discarded)
	close_requested.connect(close_button_pressed);
	@warning_ignore(return_value_discarded)
	size_changed.connect(update_global_position);
	# Connect to other Nodes' signals
	@warning_ignore(return_value_discarded)
	get_tree().root.size_changed.connect(update_local_position);
	@warning_ignore(return_value_discarded)
	Global.camera_moved.connect(update_local_position);
	# Loading needs to be done for update_local_position() to work
	await get_tree().process_frame;
	update_local_position();
	if local_filename == "":
		find_valid_name()
	load_content()

func find_valid_name() -> void:
	print("find_valid_name was not overridden!")
	return

func update_local_position():
	if being_held:
		return;
	var camera : Camera2D = get_tree().root.get_camera_2d();
	var top_left : Vector2i = Vector2i.ZERO;
	if camera != null:
		top_left = get_lop_left(camera);
	position = global_position - top_left;
	last_local_position = position;

func update_global_position():
	var camera : Camera2D = get_tree().root.get_camera_2d();
	var top_left : Vector2i = Vector2i.ZERO;
	if camera != null:
		top_left = get_lop_left(camera);
	global_position = position + top_left;
	last_local_position = position;

func get_lop_left(cam : Camera2D) -> Vector2i:
	# Might be wrong by a pixel, but it doen't matter
	return Vector2i(cam.position) - (get_tree().root.size / 2);

func save_content() -> void:
	print("save_content was not overridden!")

func load_content() -> void:
	print("load_content was not overridden!")

func get_position_data() -> Array:
	#Returns [x pos, y pos, width, height]
	return [global_position[0],global_position[1],size[0],size[1]]

func _process(_delta):
	if last_local_position != position:
		if !being_held:
			being_held = true;
			print(String(name) + " picked up");
		update_global_position();
		last_local_position = position;
	if being_held && !(Input.get_mouse_button_mask() & MOUSE_BUTTON_MASK_LEFT):
		being_held = false;
		Global.file_object_dropped.emit(self);
		print(String(name) + " dropped");

func close_button_pressed():
	# Temporary, later it should have a confirmation popup and delete the associated file
	queue_free();
