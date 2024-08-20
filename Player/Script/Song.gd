extends Panel

@export var label: Label
@export var label_number: Label
@export var texture: TextureRect

var ICON_PAUSE = preload("res://assets/texture/button/pause.png")
var ICON_PLAY = preload("res://assets/texture/button/play.png")

var name_sound: String = ""
var stream: AudioStream
var trigger: bool = false
var active: bool = false
var id: int = 0

func _ready():
	Global.current_id_sig.connect(changed_id)

func changed_id(_id):
	if id == _id:
		active = true
		Global.changed_stream(stream)
		Global.sound_name = name_sound
		texture.texture = ICON_PAUSE
	else:
		active = false
		texture.texture = ICON_PLAY

func set_up(sl_no: int, item: Dictionary):
	#print(str(sl_no)+"id")
	if label_number != null:
		label_number.text = str(sl_no + 1)
	if label != null:
		print(item)
		name_sound = str(item.nam)
		label.text = str(item.nam)
	id = sl_no + 1
	if id > Global.sound_total:
		Global.sound_total = id

	var ext = item.nam.get_extension()
	if str(ext) == "mp3": 
		stream = load_mp3(item.path)
	elif str(ext) == "ogg":
		stream = AudioStreamOggVorbis.load_from_file(item.path)


func load_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	return sound

func _on_gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			trigger = true
		else:
			if trigger:
				Global.changed_id(id)
	if event is InputEventScreenDrag:
		trigger = false
	await get_tree().create_timer(0.01).timeout
	if event is InputEventMouseButton and !trigger:
			if event.pressed and event.button_index == 1:
				Global.changed_id(id)
