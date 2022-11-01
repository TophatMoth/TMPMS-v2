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

func _ready():
	# Connect to its own signals
	close_requested.connect(close_button_pressed);
	size_changed.connect(update_global_position);
	# Connect to other Nodes' signals
	get_tree().root.size_changed.connect(update_local_position);
	Global.camera_moved.connect(update_local_position);
	# Loading needs to be done for update_local_position() to work
	await get_tree().process_frame;
	update_local_position();

func update_local_position():
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

func _process(_delta):
	if last_local_position != position:
		#print(String(name) + " moved");
		update_global_position();
		last_local_position = position;

func close_button_pressed():
	# Temporary, later it should have a confirmation popup and delete the associated file
	queue_free();
