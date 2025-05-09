extends Node

func time_to_string(time : float) -> String:
	var milliseconds : int = round(fmod(time, 1.0) * 1000)
	var seconds : int = floor(fmod(time, 60.0))
	var minutes : int = floor(time / 60.0)
	return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]

func load_data_from_json(path : String) -> Dictionary:
	var file : File = File.new()
	file.open(path, File.READ)
	var contents : String = file.get_as_text()
	file.close()
	var json : Dictionary = parse_json(contents)
	return json
