class_name Ship
extends Spatial


export (float) var max_speed := 100.0
export (float) var acceleration_time := 2.0
export (float) var deceleration_time := 1.5
export (Curve) var acceleration : Curve

export (float) var max_angle := 2.0
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

var is_dead := false


func _process(delta: float) -> void:
	if is_dead:
		return
	
	var is_accelerating := Input.is_action_pressed("accelerate")
	t_speed = update_t(t_speed, delta, acceleration_time if is_accelerating else -deceleration_time)
	speed = get_updated_value(acceleration, 0.0, -max_speed, t_speed)
	
	var current_steer_dir := sign(steer) if steer != 0 else 0.0
	var steer_dir := Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
	var is_steering := steer_dir != 0 and (steer_dir == current_steer_dir or current_steer_dir == 0)
	t_steer = update_t(t_steer, delta, steering_time if is_steering else -steer_back_time)
	steer = get_updated_value(steering, 0.0, deg2rad(max_angle) * (steer_dir if is_steering else current_steer_dir), t_steer)
	
	var rotation_axis := transform.basis.y.cross(ground_normal)
	if rotation_axis != Vector3.ZERO:
		var angle := transform.basis.y.angle_to(ground_normal)
		rotate(rotation_axis.normalized(), angle)
	
	rotate(transform.basis.y, steer)
	
	var velocity := global_transform.basis.z * speed * delta
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


func _on_HitBox_area_entered(_area: Area) -> void:
	is_dead = true
	$Graph.visible = false
	var particles : Particles = $Particles
	particles.emitting = true
	
	yield(get_tree().create_timer(particles.lifetime + 0.5), "timeout")
	
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
