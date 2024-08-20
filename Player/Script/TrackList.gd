extends VBoxContainer

var Button_Song = preload("res://Player/Scene/Song.tscn")

var fileName = []
@export var direction: String = OS.get_system_dir(OS.SYSTEM_DIR_MUSIC)
#@export var Song: Array[AudioStream]
# Called when the node enters the scene tree for the first time.
func _ready():
	var music = []
	music = get_dir_content(direction)
	dir_contents(direction)
	print(fileName)
	set_up_list(music)



func set_up_list(list: Array):
	for c in get_children():
		c.queue_free()
	for s in list.size():
		
		var ext = list[s].get_extension()
		if str(ext) == "ogg" or str(ext) == "mp3":
			var item = Button_Song.instantiate()
			var dic ={
				nam = fileName[s],
				path = list[s]
			}
			item.set_up(s, dic)
			add_child(item)


func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var ext = file_name.get_extension()
			if str(ext) == "ogg" or str(ext) == "mp3":
				if dir.current_is_dir():
					print("Found directory: " + file_name.get_base_dir())
				else:
					fileName.append(file_name)
			file_name = dir.get_next()

func get_dir_content(path: String) -> Array:
	var files = []
	var directories = []
	var dir = DirAccess.open(path)
	
	if dir.open(path):
		dir.list_dir_begin()
		add_dir(dir,files,directories)
	return files
	return directories

func add_dir(dir:DirAccess, files: Array, directories: Array):
	var file_name = dir.get_next()

	while (file_name != ""):
		var path = dir.get_current_dir()+"/"+file_name
		var ext = path.get_extension()
		if str(ext) == "ogg" or str(ext) == "mp3":
			if dir.current_is_dir():
				var sub_dir = DirAccess.open(path)
				sub_dir.list_dir_begin()
				add_dir(sub_dir, files, directories)
				directories.append(path)
			else:
				files.append(path)
		file_name = dir.get_next()
	dir.list_dir_end()



