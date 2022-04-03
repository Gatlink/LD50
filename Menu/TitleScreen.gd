extends Control


export (float) var fade_time : float = 2.0
export (float) var video_duration : float = 10.0
export (Array, Resource) var videos : Array


onready var video_player : VideoPlayer = $VideoPlayer
onready var fader : ColorRect = $Fader
onready var tween : Tween = $Tween
onready var fade_timer : Timer = $FadeTimer
onready var hide_color : Color = fader.color


var transparent : Color
var is_hidden := true
var video_index := 0


func _ready() -> void:
	transparent = hide_color
	transparent.a = 0


func _process(_delta: float) -> void:
	if not video_player.is_playing():
		play_video()


func play_video() ->  void:
	if videos.size() > 0:
		video_player.stream = videos[video_index]
		video_player.play()
		fade_timer.start(1)
		video_index = (video_index + 1) % videos.size()


func fade_in() -> void:
	is_hidden = false
# warning-ignore:return_value_discarded
	tween.interpolate_property(fader, "color", hide_color, transparent, fade_time, Tween.TRANS_QUART, Tween.EASE_IN)
# warning-ignore:return_value_discarded
	tween.start()


func fade_out() -> void:
	is_hidden = true
# warning-ignore:return_value_discarded
	tween.interpolate_property(fader, "color", transparent, hide_color, fade_time, Tween.TRANS_QUART, Tween.EASE_OUT)
# warning-ignore:return_value_discarded
	tween.start()


func _on_PlayButton_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main.tscn")


func _on_QuitButton_pressed() -> void:
	pass
	get_tree().quit()


func _on_Timer_timeout() -> void:
	if is_hidden:
		fade_in()
		fade_timer.start(video_duration - fade_time)
	else:
		fade_out()
