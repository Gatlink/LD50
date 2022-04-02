class_name Chunk
extends Spatial


signal screen_exited(chunk)


onready var end_position := $EndPosition


func _on_VisibilityNotifier_screen_exited() -> void:
	emit_signal("screen_exited", self)
