extends AnimationPlayer


export (String) var anim_name : String = "glow"


func _ready() -> void:
	play(anim_name)
