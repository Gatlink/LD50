extends Spatial


export (float) var x_min := 7.5
export (float) var x_max := 10.0
export (float) var z_min := 2.0
export (float) var z_max := 5.0


onready var obstacle_scene := preload("res://Obstacle/Obstacle.tscn")
onready var chunk_scene := preload("res://Level/Chunk.tscn")
onready var chunks_parent := $Chunks


var obstacle_z := 0.0
var obstacle_count := 0
var can_spawn := true
var chunks : Array
var last_chunk_id := 0


func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		can_spawn = false


func _ready() -> void:
	randomize()
#	call_deferred("spawn_obstacles", 100)
	
	var furthest_z := 0.0
	var id := 0
	for child in chunks_parent.get_children():
		var chunk = child as Chunk
		chunks.append(chunk)
		chunk.connect("screen_exited", self, "on_chunk_screen_exited")
		
		if chunk.translation.z < furthest_z:
			last_chunk_id = id
		id += 1


func on_chunk_screen_exited(chunk : Chunk) -> void:
	chunk.global_transform.origin = chunks[last_chunk_id].end_position.global_transform.origin
	
	for i in chunks.size():
		if chunks[i] == chunk:
			last_chunk_id = i


func spawn_obstacles(count : int) -> void:
	for i in count:
		spawn_obstacle()


func spawn_obstacle() -> void:
	var instance : Spatial = obstacle_scene.instance()
	var dir := float((randi() % 2) * 2 - 1)
	instance.translate(Vector3(rand_range(x_min, x_max) * dir, 0, obstacle_z))
	get_tree().root.add_child(instance)
	obstacle_z -= rand_range(z_min, z_max)
	obstacle_count += 1
# warning-ignore:return_value_discarded
	instance.connect("tree_exited", self, "on_obstacle_destroyed")


func on_obstacle_destroyed() -> void:
	obstacle_count -= 1
	
	if can_spawn and obstacle_count <= 50:
		spawn_obstacles(50)
