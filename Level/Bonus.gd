extends ScoreGate


func collect() -> void:
	var particles : Particles = $Particles
	particles.emitting = true
	$"LD50-Bonus-Star".visible = false
	
	yield(get_tree().create_timer(particles.lifetime + 0.1), "timeout")
	
	queue_free()
