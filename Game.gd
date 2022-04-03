extends Spatial


export (Array, PackedScene) var chunk_scenes : Array


onready var chunks_parent := $Chunks


var chunks : Array


func _ready() -> void:
	randomize()
	
	for child in chunks_parent.get_children():
		var chunk = child as Chunk
		init_chunk(chunk)


func on_chunk_screen_exited(chunk : Chunk) -> void:
	for i in chunks.size():
		if chunks[i] == chunk:
			chunks.remove(i)
			break
	
	var end_pos : Spatial = chunks[chunks.size() - 1].end_position
	var index := randi() % chunk_scenes.size()
	var new_chunk : Chunk = chunk_scenes[index].instance()
	chunks_parent.add_child(new_chunk)
	new_chunk.global_transform.origin = end_pos.global_transform.origin
	new_chunk.global_transform.basis = end_pos.global_transform.basis
	init_chunk(new_chunk)
	


func init_chunk(chunk : Chunk) -> void:
	chunks.append(chunk)
# warning-ignore:return_value_discarded
	chunk.connect("screen_exited", self, "on_chunk_screen_exited")
