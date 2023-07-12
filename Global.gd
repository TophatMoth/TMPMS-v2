extends Node

var proj_editor : ProjectEditor = null;
var dir:String = "/" #Should NOT end with '/', ex: C:/User/ProjectFolder
var base_dir:String = "/":
	set(value):
		base_dir = value
		dir = base_dir + dir_in_project
var dir_in_project:String = "/":
	set(value):
		dir_in_project = value
		dir = base_dir + dir_in_project

func _ready():
	# Screen doesn't update much so this is good;
	OS.low_processor_usage_mode = true;

func change_scene(path : String):
	proj_editor = null;
	get_tree().change_scene_to_packed(load(path));
	

