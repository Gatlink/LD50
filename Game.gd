extends Spatial


onready var chunk_scene := preload("res://Level/Chunk.tscn")
onready var chunks_parent := $Chunks


var chunks : Array
var last_chunk_id := 0


func _ready() -> void:
	randomize()
	
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
