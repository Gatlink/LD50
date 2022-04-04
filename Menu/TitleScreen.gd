extends "res://Menu/MenuScreen.gd"


const MAIN_BUS_NAME := "Master"
const MUSIC_BUS_NAME := "Music"
const EFFECTS_BUS_NAME := "SFX"


onready var main_bus_id := AudioServer.get_bus_index(MAIN_BUS_NAME)
onready var music_bus_id := AudioServer.get_bus_index(MUSIC_BUS_NAME)
onready var effects_bus_id := AudioServer.get_bus_index(EFFECTS_BUS_NAME)

onready var sound_animation : AnimationPlayer = $SoundMenuAnimation
onready var back_button : Button = $SoundMenu/Tilte/Back
onready var main_slider : HSlider = $SoundMenu/Main/HSlider
onready var main_label : Label = $SoundMenu/Main/Label
onready var music_slider : HSlider = $SoundMenu/Music/HSlider
onready var music_label : Label = $SoundMenu/Music/Label
onready var effects_slider : HSlider = $SoundMenu/Effects/HSlider
onready var effects_label : Label = $SoundMenu/Effects/Label
onready var sound_effect : AudioStreamPlayer = $AudioStreamPlayer

onready var back_selected : Texture = preload("res://Art/Menus/backSelected.png")
onready var back_normal : Texture = preload("res://Art/Menus/back.png")


var can_play_sound : bool = false


func _ready() -> void:
	main_slider.value = db2linear(AudioServer.get_bus_volume_db(main_bus_id))
	music_slider.value = db2linear(AudioServer.get_bus_volume_db(music_bus_id))
	effects_slider.value = db2linear(AudioServer.get_bus_volume_db(effects_bus_id))
	
	can_play_sound = true


func highligh_label(label : Label, is_highlighted : bool) -> void:
	label.add_color_override("font_color", Color("f0a422") if is_highlighted else Color.white)


func _process(_delta: float) -> void:
	back_button.icon = back_selected if back_button.is_hovered() or back_button.has_focus() else back_normal


func _on_SoundButton_pressed() -> void:
	sound_animation.play("ShowSoundMenu")
	main_slider.grab_focus()


func _on_Back_pressed() -> void:
	sound_animation.play("HideSoundMenu")
	play_button.grab_focus()


func _on_main_focus_entered() -> void:
	highligh_label(main_label, true)


func _on_main_focus_exited() -> void:
	highligh_label(main_label, false)


func _on_music_focus_entered() -> void:
	highligh_label(music_label, true)


func _on_music_focus_exited() -> void:
	highligh_label(music_label, false)


func _on_effects_focus_entered() -> void:
	highligh_label(effects_label, true)


func _on_effects_focus_exited() -> void:
	highligh_label(effects_label, false)


func _on_main_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(main_bus_id, linear2db(value))


func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_id, linear2db(value))


func _on_effects_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(effects_bus_id, linear2db(value))
	if can_play_sound:
		can_play_sound = false
		sound_effect.play()


func _on_sound_finished() -> void:
	can_play_sound = true
