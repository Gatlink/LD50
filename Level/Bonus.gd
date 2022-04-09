extends ScoreGate


onready var model := $"LD50-Bonus-Star"


func collect() -> void:
	var particles : Particles = $Particles
	particles.emitting = true
	model.visible = false
	
	yield(get_tree().create_timer(particles.lifetime + 0.1), "timeout")
	
	visible = false
	model.visible = true
