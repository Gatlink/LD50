class_name Ship
extends Spatial


export (float) var max_speed := 20.0
export (float) var acceleration_time := 1.0
export (float) var deceleration_time := 1.5
export (Curve) var acceleration : Curve

export (float) var max_angle := 15.0
export (float) var steering_time := 1
export (float) var steer_back_time := 1
export (Curve) var steering : Curve


onready var ground_cast : RayCast = $Rays/GroundRay3
onready var ground_position := global_transform.origin
onready var ground_normal := global_transform.basis.y


var speed : float
var t_speed : float

var steer : float
var t_steer : float


func _process(delta: float) -> void:
	var is_accelerating := Input.is_action_pressed("accelerate")
	t_speed = update_t(t_speed, delta, acceleration_time if is_accelerating else -deceleration_time)
	speed = get_updated_value(acceleration, 0.0, -max_speed, t_speed)
	
	var steer_dir := Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
	var current_steer_dir := sign(rotation.y) if rotation.y != 0 else 0.0
	var is_steering := current_steer_dir == 0 or current_steer_dir == steer_dir
	t_steer = update_t(t_steer, delta, steering_time if is_steering else -steer_back_time)
	steer = get_updated_value(steering, 0.0, max_angle * (steer_dir if is_steering else current_steer_dir), t_steer)
	steer = deg2rad(steer)
	
	global_transform.basis = Basis(
		ground_normal.rotated(Vector3.FORWARD, deg2rad(90)),
		ground_normal,
		Vector3.BACK
	)
	
	var velocity := transform.basis.z * speed * delta
	velocity += transform.basis.x * steer_dir * -max_speed * 0.01
	global_transform.origin = ground_position + velocity


func _physics_process(delta: float) -> void:
	if ground_cast.is_colliding():
		ground_position = ground_cast.get_collision_point()
		ground_normal = ground_cast.get_collision_normal()


func update_t(t : float, delta : float, duration: float) -> float:
	return clamp(t + delta / duration, 0.0, 1.0)


func get_updated_value(curve : Curve, min_value : float, max_value : float, t : float) -> float:
	return min_value + curve.interpolate(t) * max_value
