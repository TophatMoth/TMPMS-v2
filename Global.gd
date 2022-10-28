extends Node

var proj_controller : ProjectController = null;

func _ready():
	await get_tree().process_frame;
	proj_controller = get_tree().current_scene;
