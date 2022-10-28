extends Window

class_name FileObject

@export var global_position : Vector2 = Vector2(0.0, 0.0):
	set(value):
		global_position = value;
		if get_tree() != null:
			update_position();

func _ready():
	get_tree().root.size_changed.connect(viewport_resized);
	await get_tree().process_frame;
	update_position();

func update_position():
	var camera : Camera2D = get_tree().root.get_camera_2d();
	if camera == null:
		return;
	# Might be wrong by a pixel if screen size is odd, but it doen't matter
	var top_left : Vector2i = Vector2i(camera.position) - (get_tree().root.size / 2);
	position = Vector2i(global_position) - top_left;

func viewport_resized():
	update_position();
