extends AudioStreamPlayer

@export var speed_control: SpeedControl
@export var music_sections: Array[AudioStream] = []
#@export var track_speed_breakpoints: Array[float] = []
var _track_index = 0


func _ready():
	stream = music_sections[_track_index]
	play()
	connect("finished", _play_next)

#func set_next_index(index: int):
	#_track_index = clamp(index, 0, len(music_sections) - 1)

func _play_next():
	if _track_index < len(music_sections) - 1:
		_track_index += 1
	#while _track_index < len(music_sections) - 1 and speed_control.linear_speed < track_speed_breakpoints[_track_index]:
		#_track_index += 1
	#print("next track index %d" % _track_index)
	stream = music_sections[_track_index]
	play()
