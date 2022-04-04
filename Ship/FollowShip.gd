extends Path


export (NodePath) var ship_path : NodePath
export (float) var smooth : float = 0.6


onready var ship : Ship = get_node(ship_path)
onready var path_follow : PathFollow = $PathFollow


func _physics_process(_delta: float) -> void:
	path_follow.unit_offset = ship.t_speed


func _process(_delta: float) -> void:
	transform = transform.interpolate_with(ship.transform, smooth)
