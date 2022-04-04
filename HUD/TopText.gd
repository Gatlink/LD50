class_name TopText
extends Control


signal done


export (Vector2) var start_pos : Vector2 = Vector2(412, -200.0)
export (Vector2) var target_pos : Vector2 = Vector2(412, 25.0)


onready var label : Label = $Label
onready var animation : AnimationPlayer = $AnimationPlayer


func display(text : String) -> void:
	label.text = text
	animation.play("Show")


func _on_animation_finished(_anim_name: String) -> void:
	emit_signal("done")
