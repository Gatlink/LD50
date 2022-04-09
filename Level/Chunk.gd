class_name Chunk
extends Spatial


signal screen_exited(chunk)


export (Array, PackedScene) var obstacle_scenes : Array


onready var end_position := $EndPosition
onready var obstacle_holder := $Obstacles


var obstacles := []


func _ready() -> void:
	randomize()
	for obstacle_pos in obstacle_holder.get_children():
		var instance : Obstacle = obstacle_scenes[randi() % obstacle_scenes.size()].instance()
		instance.transform.origin = obstacle_pos.transform.origin
		instance.rotate(Vector3.UP, obstacle_pos.rotation.y)
		instance.rotate(Vector3.BACK, randf() * deg2rad(360))
		obstacle_holder.add_child(instance)
		obstacle_pos.queue_free()
		obstacles.append(instance)


func _on_VisibilityNotifier_screen_exited() -> void:
	emit_signal("screen_exited", self)
