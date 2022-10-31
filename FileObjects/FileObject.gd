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
	get_tree().root.size_changed.connect(viewport_resized);
	await get_tree().process_frame;
	update_local_position();

func update_local_position():
	var camera : Camera2D = get_tree().root.get_camera_2d();
	var top_left : Vector2i = Vector2i.ZERO;
	if camera != null:
		# Might be wrong by a pixel if screen size is odd, but it doen't matter
		top_left = Vector2i(camera.position) - (get_tree().root.size / 2);
	position = global_position - top_left;
	last_local_position = position;

func update_global_position():
	var camera : Camera2D = get_tree().root.get_camera_2d();
	var top_left : Vector2i = Vector2i.ZERO;
	if camera != null:
		# Might be wrong by a pixel if screen size is odd, but it doen't matter
		top_left = Vector2i(camera.position) - (get_tree().root.size / 2);
	global_position = position + top_left;
	last_local_position = position;

func viewport_resized():
	update_local_position();

func _process(_delta):
	if last_local_position != position:
		print(String(name) + " moved");
		update_global_position();
		last_local_position = position;
