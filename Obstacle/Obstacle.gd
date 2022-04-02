extends Spatial


export (float) var max_scale := 3


func _ready() -> void:
	var new_scale := rand_range(1.0, max_scale)
	scale_object_local(Vector3.ONE * new_scale)


func _on_VisibilityNotifier_screen_exited() -> void:
	queue_free()
