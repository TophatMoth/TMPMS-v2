extends Node2D
class_name ProjectController

@onready var ui : ProjectUI = $UI;

@onready var textbox_scene : PackedScene = preload("res://FileObjects/TextFileObject.tscn");
@onready var folder_scene : PackedScene = preload("res://FileObjects/FolderFileObject.tscn");
@onready var image_scene : PackedScene = preload("res://FileObjects/ImageFileObject.tscn");
@onready var scene_dict:Dictionary = {"text":textbox_scene,"folder":folder_scene,"image":image_scene}

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
			Global.change_scene("res://ProjectSelect.tscn");
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

func load_project(new_dir:String):
	if Global.dir != "/":#Test for init
		save_data()
	#Destroy Old
	for fileobject in $FileObjects.get_children():
		if fileobject is FileObject:
			fileobject.queue_free()
	
	Global.dir = new_dir
	#Grab metadata
	var metadata:Array[Dictionary] = []
	if FileAccess.file_exists(Global.dir+"/metadata.json"):
		var f:FileAccess = FileAccess.open(Global.dir+"/metadata.json",FileAccess.READ)
		metadata = JSON.parse_string(f.get_as_text())
	else:
		#Emergency Catch, shouldn't be needed under normal operations
		var f:FileAccess = FileAccess.open(Global.dir+"/metadata.json",FileAccess.WRITE)
		f.store_string(JSON.stringify([],"\t"))
	#Spawn FileObjects
	for object_metadata in metadata:
		spawn_file_object(scene_dict[object_metadata["type"]],object_metadata)
	return

func spawn_file_object(file_object_scene : PackedScene,object_metadata:Dictionary={}):
	var new_fo := file_object_scene.instantiate();
	Global.file_obj_container.add_child(new_fo);
	if new_fo is FileObject:
		new_fo.global_position = $Camera2D.position;
		if object_metadata != {}:
			new_fo.global_position = object_metadata["position"]
			new_fo.size = object_metadata["size"]
			new_fo.local_filename = object_metadata["filename"]
			if new_fo is FolderFileObject:
				new_fo.set_title(object_metadata["title"])
			new_fo.load_content()

func save_data():
	var json_lis:Array[Dictionary] = []
	for fileobject in $FileObjects.get_children():
		if fileobject is FileObject:
			fileobject.save_content()
			var dict:Dictionary = {
				"type":fileobject.get_object_type(),
				"filename":fileobject.local_filename,
				"position":fileobject.global_position,
				"size":fileobject.size
			}
			if fileobject is FolderFileObject:
				dict["title"] = fileobject.get_title()
			json_lis.append(dict)
	var f:FileAccess = FileAccess.open(Global.dir+"/metadata.json",FileAccess.WRITE)
	f.store_string(JSON.stringify(json_lis,"\t",false))
	return
