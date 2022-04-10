class_name Obstacle
extends Spatial


onready var bonus_holder : Spatial = $BonusPos
onready var bonus_positions := bonus_holder.get_children() if bonus_holder != null else []


func get_bonus_spawn_position() -> Spatial:
	if bonus_positions.size() > 0:
		return bonus_positions[randi() % bonus_positions.size()] as Spatial
	
	return null
