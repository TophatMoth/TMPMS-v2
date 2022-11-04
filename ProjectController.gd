extends Node2D
class_name ProjectController

@onready var ui : ProjectUI = $UI;

@onready var textbox_scene : PackedScene = load("res://FileObjects/TextFileObject.tscn");
@onready var folder_scene : PackedScene = load("res://FileObjects/FolderFileObject.tscn");
@onready var image_scene : PackedScene = load("res://FileObjects/ImageFileObject.tscn");

func _on_ui_button_pressed(button_id : int):
	match(button_id):
		ProjectUI.HOME:
			pass;
		ProjectUI.UP_FOLDER:
			pass;
		ProjectUI.CENTER_CAM:
			center_cam();
		ProjectUI.CENTER_FILES:
			center_cam();
			center_files();
		ProjectUI.SAVE:
			save_data();
		ProjectUI.CLOSE:
			save_data();
			get_tree().quit();
		ProjectUI.ADD_TEXTBOX:
			spawn_file_object(textbox_scene);
		ProjectUI.ADD_FOLDER:
			spawn_file_object(folder_scene);
		ProjectUI.ADD_IMAGE:
			spawn_file_object(image_scene);

func center_cam():
	$Camera2D.position = Vector2.ZERO;
	Global.emit_camera_moved();

func center_files():
	for child in $FileObjects.get_children():
		if child is FileObject:
			child.global_position = Vector2i.ZERO;

func spawn_file_object(file_object_scene : PackedScene):
	var new_fo := file_object_scene.instantiate();
	$FileObjects.add_child(new_fo);
	if new_fo is FileObject:
		new_fo.global_position = $Camera2D.position;

func save_data():
	print("Data would be saved if this function was implemented");
