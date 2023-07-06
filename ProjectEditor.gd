extends Control
class_name ProjectEditor

@onready var textbox_scene : PackedScene = preload("res://FileNodes/Text.tscn");
@onready var folder_scene : PackedScene = preload("res://FileNodes/Folder.tscn");
@onready var image_scene : PackedScene = preload("res://FileNodes/Image.tscn");
@onready var scene_dict:Dictionary = {"text":textbox_scene,"folder":folder_scene,"image":image_scene}

enum {
	HOME, UP_FOLDER,
	SAVE, CLOSE,
	ADD_TEXTBOX, ADD_FOLDER,
	ADD_IMAGE
}

func _on_ui_button_pressed(button_id : int):
	match(button_id):
		HOME:
			print("Home Pressed");
		UP_FOLDER:
			print("Up Folder Pressed");
		SAVE:
			save_data();
		CLOSE:
			save_data();
			Global.change_scene("res://ProjectSelect.tscn");
		ADD_TEXTBOX:
			spawn_file_node(textbox_scene);
		ADD_FOLDER:
			spawn_file_node(folder_scene);
		ADD_IMAGE:
			spawn_file_node(image_scene);

func _ready():
	load_project(Global.dir);

func load_project(new_dir:String):
	%DirectoryLabel.text = new_dir;
	
	if Global.dir != "/":#Test for init
		save_data()
	#Destroy Old
	for filenode in %GraphEdit.get_children():
		if filenode is FileNode:
			filenode.queue_free()
	
	Global.dir = new_dir
	if Global.dir == "/":
		return;
	#Grab metadata
	var metadata:Array[Dictionary] = []
	if FileAccess.file_exists(Global.dir+"/metadata.json"):
		var f:FileAccess = FileAccess.open(Global.dir+"/metadata.json",FileAccess.READ)
		metadata = JSON.parse_string(f.get_as_text())
	else:
		#Emergency Catch, shouldn't be needed under normal operations
		var f:FileAccess = FileAccess.open(Global.dir+"/metadata.json",FileAccess.WRITE)
		f.store_string(JSON.stringify([],"\t"))
	#Spawn FileNodes
	for node_metadata in metadata:
		spawn_file_node(scene_dict[node_metadata["type"]],node_metadata)
	return

func spawn_file_node(file_node_scene : PackedScene,metadata:Dictionary={}):
	var new_fn := file_node_scene.instantiate();
	%GraphEdit.add_child(new_fn);
	if new_fn is FileNode:
		new_fn.position_offset = %GraphEdit.scroll_offset + (%GraphEdit.size * 0.5) - (new_fn.size * 0.5);
		if metadata != {}:
			new_fn.position_offset = metadata["position"]
			new_fn.size = metadata["size"]
			new_fn.local_filename = metadata["filename"]
			if new_fn is FolderNode:
				new_fn.folder_set_title(metadata["title"])
			new_fn.load_content()

func save_data():
	if Global.dir == "/":
		return;
	var json_lis:Array[Dictionary] = []
	for filenode in %GraphEdit.get_children():
		if filenode is FileNode:
			filenode.save_content()
			json_lis.append(filenode.get_dict());
	var f:FileAccess = FileAccess.open(Global.dir+"/metadata.json",FileAccess.WRITE)
	f.store_string(JSON.stringify(json_lis,"\t",false))
	return
