extends Spatial


export (Array, PackedScene) var chunk_scenes : Array


onready var chunks_parent := $Chunks
onready var music : AudioStreamPlayer = $Music
onready var tween : Tween = $Tween
onready var blocker : Spatial = $Blocker


var chunks : Array


func _ready() -> void:
	randomize()
	
	for child in chunks_parent.get_children():
		var chunk = child as Chunk
		init_chunk(chunk)


func on_chunk_screen_exited(chunk : Chunk) -> void:
	if chunks[0] != chunk:
		return
	
	chunks.remove(0)
	chunk.queue_free()
	
	var end_pos : Spatial = chunks[chunks.size() - 1].end_position
	var index := randi() % chunk_scenes.size()
	var new_chunk : Chunk = chunk_scenes[index].instance()
	chunks_parent.add_child(new_chunk)
	new_chunk.global_transform.origin = end_pos.global_transform.origin
	new_chunk.global_transform.basis = end_pos.global_transform.basis
	init_chunk(new_chunk)
	
	blocker.global_transform = chunks[0].global_transform


func init_chunk(chunk : Chunk) -> void:
	chunks.append(chunk)
# warning-ignore:return_value_discarded
	chunk.connect("screen_exited", self, "on_chunk_screen_exited")


func _on_Ship_crashed() -> void:
# warning-ignore:return_value_discarded
	tween.interpolate_property(music, "volume_db", music.volume_db, -80, 1, Tween.TRANS_CUBIC, Tween.EASE_IN)
# warning-ignore:return_value_discarded
	tween.start()


func _on_Timer_timeout() -> void:
	var chunk : Chunk = chunks[chunks.size() - 1]
	var count := chunk.obstacle_holder.get_child_count()
	for i in count:
		var index : int = count - 1 - i
		var obstacle := chunk.obstacle_holder.get_child(index) as Obstacle
		if obstacle != null:
			obstacle.spawn_bonus()
			break
