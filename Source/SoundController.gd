extends Node

var threads = []
export var threadCount = 1
export var volumeScale = 1.0

func _configure_thread(stream) -> AudioStreamPlayer:
	var thread = AudioStreamPlayer.new()
	thread.stream = stream
	thread.volume_db = linear2db(volumeScale)
	thread.play()
	return(thread)

func play(stream):
	if !stream:
		return
	
	var thread = _configure_thread(stream)
	threads.push_back(thread)
	add_child(thread)
	if threads.size() > threadCount:
		thread = threads.pop_front().queue_free()
