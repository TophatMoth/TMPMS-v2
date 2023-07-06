extends FileNode
class_name ImageNode

func get_object_type():
	return "image"
	
func save_content():
	return

func load_content():
	if Global.dir == "/":
		return;
	var img:Image = Image.new()
	img.load(Global.dir+'/'+local_filename)
	$TextureRect.texture = ImageTexture.create_from_image(img)
	return

func find_valid_filename() -> void:
	if Global.dir == "/":
		return;
	print("No Valid Image Path Gromit!")
	return
