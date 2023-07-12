extends Control
class_name ProjectEditor

@onready var textbox_scene : PackedScene = preload("res://FileNodes/Text.tscn");
@onready var folder_scene : PackedScene = preload("res://FileNodes/Folder.tscn");
@onready var image_scene : PackedScene = preload("res://FileNodes/Image.tscn");
@onready var scene_dict:Dictionary = {"text":textbox_scene,"folder":folder_scene,"image":image_scene}
@onready var graph_edit : GraphEdit = %GraphEdit;
var folder_display_name_stack:Array = []


enum {
	HOME, UP_FOLDER,
	SAVE, CLOSE,
	ADD_TEXTBOX, ADD_FOLDER,
	ADD_IMAGE
}

func _on_ui_button_pressed(button_id : int):
	match(button_id):
		HOME:
			folder_display_name_stack.clear()
			load_project("")
		UP_FOLDER:
			if Global.dir_in_project != "":
				folder_display_name_stack.pop_back()
				load_project(Global.dir_in_project.get_base_dir())
		SAVE:
			save_data();
		CLOSE:
			save_data();
			Global.change_scene("res://ProjectSelect.tscn");
		ADD_TEXTBOX:
			spawn_file_node(textbox_scene);
			save_data()
		ADD_FOLDER:
			spawn_file_node(folder_scene);
			save_data()
		ADD_IMAGE:
			spawn_file_node(image_scene);

func _ready():
	Global.proj_editor = self
	load_project("",true);

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		Global.proj_editor = null

func load_project(new_dir_in_project:String,first_load:bool=false):
	if Global.dir == "/":#Test for editor
		return
	if !first_load:
		save_data()
	
	#Destroy Old
	for filenode in %GraphEdit.get_children():
		if filenode is FileNode:
			filenode.queue_free()
	graph_edit.scroll_offset = Vector2.ZERO;
	
	Global.dir_in_project = new_dir_in_project
	
	%DirectoryLabel.text = "/"
	for folder in folder_display_name_stack:
		%DirectoryLabel.text += folder + '/'

	#Grab metadata
	var metadata:Array = []
	if FileAccess.file_exists(Global.dir+"/metadata.json"):
		var f:FileAccess = FileAccess.open(Global.dir+"/metadata.json",FileAccess.READ)
		metadata = JSON.parse_string(f.get_as_text())
	else:
		#Create blank metadata file if one doesn't exist
		var f:FileAccess = FileAccess.open(Global.dir+"/metadata.json",FileAccess.WRITE)
		f.store_string(JSON.stringify([],"\t"))
	#Spawn FileNodes
	for node_metadata in metadata:
		# ADD LOAD CONNECTIONS FOR GRAPH TODO
		spawn_file_node(scene_dict[node_metadata["type"]],node_metadata)
	return

func spawn_file_node(file_node_scene : PackedScene,metadata:Dictionary={}):
	var new_fn := file_node_scene.instantiate();
	if new_fn is FileNode:
		new_fn.position_offset = graph_edit.scroll_offset + (graph_edit.size * 0.5) - (new_fn.size * 0.5);
		if metadata != {}:
			new_fn.position_offset = Vector2(metadata["position"][0],metadata["position"][1])
			new_fn.size = Vector2(metadata["size"][0],metadata["size"][1])
			new_fn.local_filename = metadata["filename"]
			if new_fn is FolderNode:
				new_fn.folder_set_title(metadata["title"])
			new_fn.load_content()
	graph_edit.add_child(new_fn);


func save_data():
	if Global.dir == "/":
		return;
	var json_lis:Array[Dictionary] = []
	for filenode in graph_edit.get_children():
		if filenode is FileNode:
			filenode.save_content()
			json_lis.append(filenode.get_dict());
	# ADD SAVE FOR CONNECTIONS ON GRAPH
	var f:FileAccess = FileAccess.open(Global.dir+"/metadata.json",FileAccess.WRITE)
	f.store_string(JSON.stringify(json_lis,"\t",false))
	return
