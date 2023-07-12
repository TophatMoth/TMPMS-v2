extends Control

@export_multiline var project_file_contents:Array[String] = []

func _ready():
	randomize()
	%LoadDialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	%SaveDialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	%SaveDialog.current_file = "New_Project"

func make_new_project(path:String):
	var f:FileAccess = FileAccess.open(path,FileAccess.WRITE)
	f.store_string(project_file_contents.pick_random())
	load_project(path)

func load_project(path:String):
	Global.base_dir = path.get_base_dir()
	Global.dir_in_project = ""
	Global.change_scene("res://ProjectEditor.tscn")

