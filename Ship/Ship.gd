extends Spatial


export (float) var max_speed := 50.0
export (float) var acceleration_time := 1.0
export (float) var deceleration_time := 2.0
export (Curve) var acceleration : Curve


var speed : float
var t : float


func _process(delta: float) -> void:
	var is_accelerating := Input.is_action_pressed("Accelerate")
	t += delta / acceleration_time if is_accelerating else -delta / deceleration_time
	t = clamp(t, 0.0, 1.0)
	speed = acceleration.interpolate(t) * -max_speed


func _physics_process(delta: float) -> void:
	translate(global_transform.basis.z * speed * delta)
