extends Spatial


export (int) var chunks_count_before_bonus := 3


onready var chunks_parent := $Chunks
onready var chunk_pool := $ChunkPool
onready var music : AudioStreamPlayer = $Music
onready var tween : Tween = $Tween
onready var blocker : Spatial = $Blocker
onready var last_bonus_spawned := 0
onready var bonuses := $BonusPool.get_children()
onready var chunk_timer : Timer = $ChunkTimer


var should_spawn_chunk := false
var chunks : Array
var current_bonus := 0
var total_weight : int


func _ready() -> void:
	randomize()
	
	for child in chunk_pool.get_children():
		var chunk := child as Chunk
		if chunk != null:
			total_weight += chunk.weight
	
	for child in chunks_parent.get_children():
		var chunk = child as Chunk
		if chunk != null:
			chunk.generate_obstacles()
			chunks.append(chunk)


func _process(_delta: float) -> void:
	if last_bonus_spawned >= chunks_count_before_bonus:
		spawn_bonus(chunks[chunks.size() - 1])
		last_bonus_spawned = 0
	
	if should_spawn_chunk:
		spawn_chunk()

 
func spawn_chunk() -> void:
	var old_chunk : Chunk = chunks[0]
	chunks.remove(0)
	
	var end_transform : Transform = chunks[chunks.size() - 1].get_next_transform()
	var weight := randi() % total_weight
	for child in chunk_pool.get_children():
		var new_chunk := child as Chunk
		if new_chunk != null and weight <= new_chunk.weight:
			total_weight -= new_chunk.weight
			new_chunk.visible = true
			chunk_pool.remove_child(new_chunk)
			chunks_parent.add_child(new_chunk)
			new_chunk.global_transform = end_transform
			new_chunk.generate_obstacles()
			new_chunk.gate.activate()
			chunks.append(new_chunk)
			break
		else:
			weight -= new_chunk.weight
	
	if old_chunk.is_pooled:
		old_chunk.visible = false
		old_chunk.clean_obstacles()
		chunks_parent.remove_child(old_chunk)
		chunk_pool.add_child(old_chunk)
		total_weight += old_chunk.weight
	else:
		old_chunk.queue_free()
	
	last_bonus_spawned += 1
	should_spawn_chunk = false
	
	blocker.global_transform = chunks[0].global_transform


func spawn_bonus(chunk : Chunk) -> void:
	var count := chunk.obstacles.size()
	for i in count:
		var index : int = count - 1 - i
		var obstacle := chunk.obstacles[index] as Obstacle
		var pos := obstacle.get_bonus_spawn_position()
		if pos != null:
			var bonus : Spatial = bonuses[current_bonus]
			current_bonus = (current_bonus + 1) % bonuses.size()
			bonus.global_transform = pos.global_transform
			bonus.visible = true
			break


func _on_Ship_crashed() -> void:
# warning-ignore:return_value_discarded
	tween.interpolate_property(music, "volume_db", music.volume_db, -80, 1, Tween.TRANS_CUBIC, Tween.EASE_IN)
# warning-ignore:return_value_discarded
	tween.start()


func _on_Ship_crossed_gate() -> void:
	chunk_timer.start()


func _on_ChunkTimer_timeout() -> void:
	should_spawn_chunk = true
