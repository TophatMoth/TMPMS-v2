extends Node2D
class_name ProjectController

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
			pass;
		ProjectUI.CLOSE:
			pass;
		ProjectUI.ADD_TEXTBOX:
			pass;
		ProjectUI.ADD_FOLDER:
			pass;
		ProjectUI.ADD_IMAGE:
			pass;

func center_cam():
	$Camera2D.position = Vector2.ZERO;
	Global.emit_camera_moved();

func center_files():
	for child in $FileObjects.get_children():
		if child is FileObject:
			child.global_position = Vector2i.ZERO;
