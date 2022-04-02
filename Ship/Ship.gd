class_name Ship
extends Spatial


export (float) var max_speed := 50.0
export (float) var acceleration_time := 1.0
export (float) var deceleration_time := 1.5
export (Curve) var acceleration : Curve

export (float) var max_angle := 15.0
export (float) var steering_time := 0.5
export (float) var steer_back_time := 0.1
export (Curve) var steering : Curve

export (float) var normal_smooth := 0.1


onready var ground_ray : RayCast = $Rays/GroundRayMid
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
	
	var current_steer_dir := sign(steer) if steer != 0 else 0.0
	var steer_dir := Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
	var is_steering := steer_dir != 0 and (steer_dir == current_steer_dir or current_steer_dir == 0)
	t_steer = update_t(t_steer, delta, steering_time if is_steering else -steer_back_time)
	steer = get_updated_value(steering, 0.0, deg2rad(max_angle) * (steer_dir if is_steering else current_steer_dir), t_steer)
	
	var forward := Vector3.BACK.rotated(ground_normal, steer)
	global_transform.basis = Basis(
		ground_normal.rotated(forward, deg2rad(-90)),
		ground_normal,
		forward
	)
	
	var velocity := forward * speed * delta
	global_transform.origin = ground_position + velocity


func _physics_process(_delta: float) -> void:
	if ground_ray.is_colliding():
		ground_position = ground_ray.get_collision_point()
		ground_normal = ground_ray.get_collision_normal() * normal_smooth + (1 - normal_smooth) * ground_normal
		ground_normal = ground_normal.normalized()


func update_t(t : float, delta : float, duration: float) -> float:
	return clamp(t + delta / duration, 0.0, 1.0)


func get_updated_value(curve : Curve, min_value : float, max_value : float, t : float) -> float:
	return min_value + curve.interpolate(t) * max_value
