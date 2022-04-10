class_name Chunk
extends Spatial


export (Array, PackedScene) var obstacle_scenes : Array
export (String, "x", "y", "z") var exit_axis : String = "y"
export (float, -180, 180, 30) var exit_angle := 0.0


onready var end_position := $"Pipe/Pipes-Target_Out"
onready var obstacle_holder := $Obstacles


var obstacles := []


func _ready() -> void:
	for obstacle_pos in obstacle_holder.get_children():
		var instance : Obstacle = obstacle_scenes[randi() % obstacle_scenes.size()].instance()
		instance.translation = obstacle_pos.translation
		instance.rotate(Vector3.BACK, randf() * deg2rad(360))
		instance.rotate(Vector3.UP, obstacle_pos.rotation.y)
		obstacle_holder.add_child(instance)
		obstacle_pos.queue_free()
		obstacles.append(instance)
		obstacles.append(instance)


func get_next_transform() -> Transform:
	var basis : Basis = end_position.global_transform.basis.rotated(
		end_position.global_transform.basis.y.normalized(),
		deg2rad(180)
	)
	var axis : Vector3
	
	match exit_axis:
		"x":
			axis = basis.x.normalized()
		"y":
			axis = basis.y.normalized()
		"z":
			axis = basis.z.normalized()
	
	var angle := deg2rad(exit_angle)
	return Transform(
		basis.rotated(axis, angle),
		end_position.global_transform.origin
	)
