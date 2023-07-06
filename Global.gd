extends Node

var proj_controller : ProjectEditor = null;
var dir:String = "/" #Should NOT end with '/', ex: C:/User/ProjectFolder

func _ready():
	process_priority = 1;
	await get_tree().process_frame;
	new_scene_loaded();
	
	# Screen doesn't update much so this is good
	OS.low_processor_usage_mode = true;

func change_scene(path : String):
	proj_controller = null;
	get_tree().change_scene_to_packed(load(path));
	await get_tree().process_frame;
	new_scene_loaded();

func new_scene_loaded():
	if get_tree().current_scene is ProjectEditor:
		proj_controller = get_tree().current_scene;
	else:
		proj_controller = null;
