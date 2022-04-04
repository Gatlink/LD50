extends Control


export (float) var fade_time : float = 2.0
export (float) var video_duration : float = 10.0
export (Array, Resource) var videos : Array


onready var music := preload("res://SFX/vacation-collective-fe77a-main-version-02-52-3714.mp3")
onready var focus_icon : Texture = preload("res://Art/Menus/selector.png")
onready var video_player : VideoPlayer = $VideoPlayer
onready var fader : ColorRect = $Fader
onready var tween : Tween = $Tween
onready var fade_timer : Timer = $FadeTimer
onready var play_button : Button = $Buttons/PlayButton
onready var sound_button : Button = $Buttons/SoundButton
onready var quit_button : Button = $Buttons/QuitButton
onready var hide_color : Color = fader.color
onready var keyboard_input : Array = get_tree().get_nodes_in_group("Keyboard")
onready var gamepad_input : Array = get_tree().get_nodes_in_group("Gamepad")


var transparent : Color
var is_hidden := true
var video_index := 0


func _input(event: InputEvent) -> void:
	if (event.is_action("ui_down") or event.is_action("ui_up")) and quit_button.get_focus_owner() == null:
		play_button.call_deferred("grab_focus")
	
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		hide_input(keyboard_input)
		show_input(gamepad_input)
	elif event is InputEventKey:
		hide_input(gamepad_input)
		show_input(keyboard_input)


func show_input(inputs : Array) -> void:
	for input in inputs:
		input.visible = true


func hide_input(inputs : Array) -> void:
	for input in inputs:
		input.visible = false


func _ready() -> void:
	transparent = hide_color
	transparent.a = 0
	
	var stream := AudioStreamPlayer.new()
	stream.stream = music
	stream.bus = "Music"
	add_child(stream)
	stream.play()


func _process(_delta: float) -> void:
	if not video_player.is_playing():
		play_video()


func play_video() ->  void:
	if videos.size() > 0:
		video_player.stream = videos[video_index]
		video_player.play()
		_on_Timer_timeout()
		video_index = (video_index + 1) % videos.size()


func fade_in() -> void:
	is_hidden = false
# warning-ignore:return_value_discarded
	tween.interpolate_property(fader, "color", fader.color, transparent, fade_time, Tween.TRANS_QUART, Tween.EASE_IN)
# warning-ignore:return_value_discarded
	tween.start()


func fade_out() -> void:
	is_hidden = true
# warning-ignore:return_value_discarded
	tween.interpolate_property(fader, "color", fader.color, hide_color, fade_time, Tween.TRANS_QUART, Tween.EASE_OUT)
# warning-ignore:return_value_discarded
	tween.start()


func _on_PlayButton_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main.tscn")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_Timer_timeout() -> void:
# warning-ignore:return_value_discarded
	tween.stop_all()
	if is_hidden:
		fade_in()
		fade_timer.start(video_duration - fade_time)
	else:
		fade_out()


func _on_button_focus_entered() -> void:
	play_button.icon = focus_icon if play_button.has_focus() else null
	sound_button.icon = focus_icon if sound_button.has_focus() else null
	quit_button.icon = focus_icon if quit_button.has_focus() else null
