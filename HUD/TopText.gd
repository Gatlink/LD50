class_name TopText
extends Control


signal done


onready var label : Label = $Label
onready var animation : AnimationPlayer = $AnimationPlayer
onready var sfx : AudioStreamPlayer = $SFX


func display(text : String) -> void:
	label.text = text
	animation.play("Show")


func _on_animation_finished(_anim_name: String) -> void:
	emit_signal("done")
