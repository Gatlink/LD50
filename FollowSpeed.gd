extends PathFollow


export (NodePath) var ship_path : NodePath


onready var ship : Ship = get_node(ship_path)


func _physics_process(_delta: float) -> void:
	unit_offset = ship.t_speed
