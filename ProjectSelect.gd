extends Control

@export_multiline var project_file_contents:Array[String] = []
const RECENT_PROJECTS_FILE_PATH : String = "user://recent_projects.json";

func _ready():
	randomize()
	%LoadDialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	%SaveDialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	%SaveDialog.current_file = "New_Project"
	
	for project in get_recent_project_list():
		if !FileAccess.file_exists(project):
			remove_recent_project(project);
			continue;
		var new_child = preload("res://RecentProjectButton.tscn").instantiate();
		%RecentProjects.add_child(new_child);
		new_child.get_node("%Label").text = project;
		new_child.pressed.connect(func():
			load_project(project);
		);

func make_new_project(path:String):
	var f:FileAccess = FileAccess.open(path,FileAccess.WRITE)
	f.store_string(project_file_contents.pick_random())
	load_project(path)

func load_project(path:String):
	add_recent_project(path);
	Global.base_dir = path.get_base_dir()
	Global.dir_in_project = ""
	Global.change_scene("res://ProjectEditor.tscn")

func get_recent_project_list() -> Array:
	if FileAccess.file_exists(RECENT_PROJECTS_FILE_PATH):
		return JSON.parse_string(
			FileAccess.open(RECENT_PROJECTS_FILE_PATH, FileAccess.READ).get_as_text()
		);
	return [];

func add_recent_project(path:String):
	var recent_project_list : Array = get_recent_project_list();
	if path in recent_project_list:
		recent_project_list.erase(path);
	recent_project_list.push_front(path);
	
	FileAccess.open(RECENT_PROJECTS_FILE_PATH, FileAccess.WRITE)\
	.store_string(JSON.stringify(recent_project_list, "\t"));

func remove_recent_project(path:String):
	var recent_project_list : Array = get_recent_project_list();
	recent_project_list.erase(path);
	FileAccess.open(RECENT_PROJECTS_FILE_PATH, FileAccess.WRITE)\
	.store_string(JSON.stringify(recent_project_list, "\t"));
