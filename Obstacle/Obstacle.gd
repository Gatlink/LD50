class_name Obstacle
extends Spatial


onready var bonus_scene : PackedScene = preload("res://Level/Bonus.tscn")
onready var bonus_holder : Spatial = $BonusPos


func spawn_bonus() -> void:
	if bonus_holder != null and bonus_holder.get_child_count() > 0:
		var child := bonus_holder.get_child(randi() % bonus_holder.get_child_count())
		var instance := bonus_scene.instance() as Spatial
		child.add_child(instance)
