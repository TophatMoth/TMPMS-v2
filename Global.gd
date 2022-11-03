extends Node

signal camera_moved;
signal file_object_dropped(file_object);

var file_obj_container : Node = null;
var proj_controller : ProjectController = null;
var mouse_position : Vector2i = Vector2i.ZERO:
	get:
		if last_frame_calculated != Engine.get_process_frames():
			mouse_position = get_mouse_pos();
			last_frame_calculated = Engine.get_process_frames();
		return mouse_position;
var last_frame_calculated : int = -1;

func _ready():
	process_priority = 1;
	await get_tree().process_frame;
	if get_tree().current_scene is ProjectController:
		proj_controller = get_tree().current_scene;

func emit_camera_moved():
	camera_moved.emit();

#func _process(_delta):
	#if Engine.get_process_frames() % 4 == 0:
	#	print(mouse_position);

func get_mouse_pos() -> Vector2i:
	if get_tree().root.has_focus():
		return Vector2i(get_tree().root.get_mouse_position());
	
	if proj_controller != null && is_instance_valid(proj_controller):
		for child in proj_controller.ui.get_children():
			if child is Window:
				if child.has_focus():
					return Vector2i(child.get_mouse_position()) + child.position;
	
	if file_obj_container != null && is_instance_valid(file_obj_container):
		for child in file_obj_container.get_children():
			if child is Window:
				if child.has_focus():
					return Vector2i(child.get_mouse_position()) + child.position;
	
	return Vector2i.ZERO;
