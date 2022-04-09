extends Spatial


export (Array, PackedScene) var chunk_scenes : Array
export (int) var chunks_count_before_bonus := 3


onready var chunks_parent := $Chunks
onready var music : AudioStreamPlayer = $Music
onready var tween : Tween = $Tween
onready var blocker : Spatial = $Blocker
onready var last_bonus_spawned := 0
onready var bonuses := $BonusPool.get_children()


var should_spawn_chunk := false
var chunks : Array
var current_bonus := 0


func _ready() -> void:
	randomize()
	
	for child in chunks_parent.get_children():
		var chunk = child as Chunk
		init_chunk(chunk)


func _process(_delta: float) -> void:
	if last_bonus_spawned >= chunks_count_before_bonus:
		spawn_bonus(chunks[chunks.size() - 1])
		last_bonus_spawned = 0
	
	if should_spawn_chunk:
		spawn_chunk()


func spawn_chunk() -> void:
	var chunk : Spatial = chunks[0]
	chunks.remove(0)
	chunk.queue_free()
	
	var end_pos : Spatial = chunks[chunks.size() - 1].end_position
	var index := randi() % chunk_scenes.size()
	var new_chunk : Chunk = chunk_scenes[index].instance()
	chunks_parent.add_child(new_chunk)
	new_chunk.global_transform.origin = end_pos.global_transform.origin
	new_chunk.global_transform.basis = end_pos.global_transform.basis
	init_chunk(new_chunk)
	
	last_bonus_spawned += 1
	should_spawn_chunk = false
	
	blocker.global_transform = chunks[0].global_transform


func on_chunk_screen_exited(chunk : Chunk) -> void:
	should_spawn_chunk = chunks[0] == chunk


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


func init_chunk(chunk : Chunk) -> void:
	chunks.append(chunk)
# warning-ignore:return_value_discarded
	chunk.connect("screen_exited", self, "on_chunk_screen_exited")


func _on_Ship_crashed() -> void:
# warning-ignore:return_value_discarded
	tween.interpolate_property(music, "volume_db", music.volume_db, -80, 1, Tween.TRANS_CUBIC, Tween.EASE_IN)
# warning-ignore:return_value_discarded
	tween.start()
