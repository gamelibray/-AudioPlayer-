extends Node

signal streams(stream)
signal current_id_sig(id)

var stream
var sound_name = ""
var current_id: int = 0
var sound_total: int = 0

func changed_stream(stre):
	stream = stre
	emit_signal("streams", stream)

func changed_id(id):
	current_id = id
	emit_signal("current_id_sig", current_id)
