class_name Obstacle
extends Spatial


#onready var bonus_scene : PackedScene = preload("res://Level/Bonus.tscn")
onready var bonus_holder : Spatial = $BonusPos
onready var bonus_positions := bonus_holder.get_children() if bonus_holder != null else []


func get_bonus_spawn_position() -> Spatial:
	if bonus_positions.size() > 0:
		return bonus_positions[randi() % bonus_positions.size()] as Spatial
#		var position : Spatial = bonus_positions[randi() % bonus_positions.size()]
#		var instance := bonus_scene.instance() as Spatial
#		position.add_child(instance)
	
	return null
