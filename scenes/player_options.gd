extends Node

const options_file_path = "user://options.json"
var _options = {}

func _ready():
	if not FileAccess.file_exists(options_file_path):
		return
	
	var options_file = FileAccess.open(options_file_path, FileAccess.READ)
	_options = JSON.parse_string(options_file.get_as_text())
	
	if _options == null:
		_options = {}

func save():
	var options_file = FileAccess.open(options_file_path, FileAccess.WRITE)
	options_file.store_string(JSON.stringify(_options))

func get_option(option_name: String, default: Variant) -> Variant:
	if _options.has(option_name):
		return _options[option_name]
	else:
		_options[option_name] = default
		return default

func set_option(option_name: String, value: Variant, do_save: bool = true):
	_options[option_name] = value
	if do_save:
		save()
