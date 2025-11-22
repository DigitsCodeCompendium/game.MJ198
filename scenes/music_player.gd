extends AudioStreamPlayer

@export var speed_control: SpeedControl
@export var music_sections: Array[AudioStream] = []
var _track_index = 0


func _ready():
	stream = music_sections[_track_index]
	play()
	connect("finished", _play_next)

#func set_next_index(index: int):
	#_track_index = clamp(index, 0, len(music_sections) - 1)

func _play_next():
	_track_index = int(speed_control.linear_speed * 0.07)
	_track_index = clamp(_track_index, 0, len(music_sections))
	print("next track index %d" % _track_index)
	stream = music_sections[_track_index]
	play()
