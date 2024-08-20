extends Control

@onready var player = $AudioStreamPlayer
@onready var slider = $Interact/Control/HSlider
@onready var time_label = $Interact/Control/Label
@onready var label_current_time = $Interact/Control/Label3
@onready var button_play = $Interact/HBoxContainer/Play_Pause
@onready var anim = $AnimationPlayer
@onready var info: Control = $Info
@onready var music_path: LabelAutoSizer = $Info/VBoxContainer/MusicPath

@export var label_name: Label
@export var direction: String = OS.get_system_dir(OS.SYSTEM_DIR_MUSIC)

var ICON_PAUSE = preload("res://assets/texture/button/pause.png")
var ICON_PLAY = preload("res://assets/texture/button/play.png")

var drag: bool = false
var time_value: float = 0.0
var loop: bool = false
var track_list: bool = false
var rand: bool = false
var rand_id: int = 0
var current_id: int = 0


func _ready():
	Global.streams.connect(changed_track)

func changed_track(stream):
	player.stream = stream
	player.play()





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("back"):
		current_id = Global.current_id
		if current_id > 1:
			current_id -= 1
		elif current_id <= 1:
			current_id = Global.sound_total
		Global.changed_id(current_id)
	
	if Input.is_action_just_pressed("next"):
		current_id = Global.current_id
		if current_id < Global.sound_total:
			current_id += 1
		elif current_id >= Global.sound_total:
			current_id = 1
		Global.changed_id(current_id)
	
	if Input.is_action_just_pressed("hide"):
		if info.visible == true:
			info.hide()
		else:
			info.visible = true
	
	if Input.is_action_just_pressed("stop"):
		play_pause()
	if label_name != null:
		label_name.text = Global.sound_name
	if player.playing:
		button_play.icon = ICON_PAUSE
		var minutes_track = int(player.stream.get_length() / 60)
		var seconds_track = int(player.stream.get_length() - minutes_track * 60)
		var minutes = int(player.get_playback_position() / 60)
		var seconds = int(player.get_playback_position() - minutes * 60)
		slider.max_value = player.stream.get_length()
		time_label.text = str(minutes_track) + ":" + str(seconds_track)
		label_current_time.text = str(minutes) + ":" + str(seconds)
		if !drag:
			slider.value = player.get_playback_position()
	else:
		button_play.icon = ICON_PLAY
		if player.stream_paused == false and slider.value != 0:
			slider.value = 0
	
	music_path.text = "MusicPath: " + direction


func _on_h_slider_value_changed(value):
	time_value = value


func _on_h_slider_gui_input(event):
	if event is InputEventScreenTouch: 
		if event.pressed:
			drag = true
		else:
			drag = false
			player.seek(time_value)
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			drag = true
		else:
			if event.button_index == 1:
				drag = false
				player.seek(time_value)


func _on_play_pause_pressed():
	play_pause()

func play_pause():
	if player.playing:
		player.stream_paused = true
	else:
		if player.stream_paused == true:
			player.stream_paused = false
		else:
			player.playing = true
		if player.stream == null:
			Global.changed_id(1)


func _on_loop_toggled(toggled_on):
	loop = toggled_on


func _on_audio_stream_player_finished():
	if loop:
		player.play()
	elif rand:
		rand_sound()
	else:
		current_id = Global.current_id
		if current_id < Global.sound_total:
			current_id += 1
		elif current_id >= Global.sound_total:
			current_id = 1
		Global.changed_id(current_id)

func rand_sound():
	rand_id = randi_range(1, Global.sound_total)
	if rand_id == Global.current_id:
		rand_sound()
	else:
		Global.changed_id(rand_id)
	print(rand_id)

func _on_button_pressed():
	if track_list:
		track_list = false
		anim.play_backwards("track_list")
	else:
		track_list = true
		anim.play("track_list")


func _on_rand_toggled(toggled_on):
	rand = toggled_on


func _on_button_4_pressed():
	current_id = Global.current_id
	if current_id < Global.sound_total:
		current_id += 1
	elif current_id >= Global.sound_total:
		current_id = 1
	Global.changed_id(current_id)


func _on_back_sound_pressed():
	current_id = Global.current_id
	if current_id > 1:
		current_id -= 1
	elif current_id <= 1:
		current_id = Global.sound_total
	Global.changed_id(current_id)

