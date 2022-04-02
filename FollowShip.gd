extends RemoteTransform


export (NodePath) var look_at_path : NodePath


onready var look_at_node : Spatial = get_node(look_at_path)


func _physics_process(_delta: float) -> void:
	look_at(look_at_node.global_transform.origin, Vector3.UP)
	
