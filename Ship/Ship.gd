class_name Ship
extends Spatial


export (float) var min_speed := 35.0
export (float) var max_speed := 100.0
export (float) var acceleration_time := 2.0
export (float) var deceleration_time := 1.0
export (Curve) var acceleration : Curve

export (float) var max_angle := 2.0
export (float) var steering_time := 0.5
export (float) var steer_back_time := 0.1
export (Curve) var steering : Curve

export (float) var normal_smooth := 0.1
export (float) var max_tilt := 30.0
export (float) var max_yaw := 10.0
export (float) var tilt_duration := 0.2


onready var ground_ray : RayCast = $Rays/GroundRayMid
onready var graph : Spatial = $Graph
onready var animation_tree : AnimationTree = $AnimationTree
onready var ground_position := global_transform.origin
onready var ground_normal := global_transform.basis.y
onready var average_speed := min_speed + (max_speed - min_speed) * 0.5


var speed : float
var t_speed : float = 0.5

var steer : float
var t_steer : float

var is_dead := false

var tilt : float
var t_tilt : float


func _process(delta: float) -> void:
	if is_dead:
		return
	
	# SPEED
	var acceleration_target := Input.get_axis("brake", "accelerate")
	var dir := sign(acceleration_target) if acceleration_target != 0 else -sign(t_speed - 0.5)
	if dir == 0:
		dir = 1
	t_speed += dir * delta / (acceleration_time if dir > 0 else deceleration_time)
	var t_min := 0.5 if t_speed >= 0.5 and acceleration_target == 0 else 0.0
	var t_max := 0.5 if t_speed <= 0.5 and acceleration_target == 0 else 1.0
	t_speed = clamp(t_speed, t_min, t_max)
	speed = -lerp(min_speed, max_speed, acceleration.interpolate(t_speed))
	if speed == 0:
		print("BOOM")
	
	# STEERING
	var current_steer_dir := sign(steer) if steer != 0 else 0.0
	var steer_dir := Input.get_axis("steer_right", "steer_left")
	var is_steering := steer_dir != 0 and (steer_dir == current_steer_dir or current_steer_dir == 0)
	t_steer = clamp(t_steer + delta / (steering_time if is_steering else -steer_back_time), 0, 1)
	steer = steering.interpolate(t_steer) * deg2rad(max_angle) * (steer_dir if is_steering else current_steer_dir)
	
	# UPDATE TRANSFORM
	var rotation_axis := transform.basis.y.cross(ground_normal)
	if rotation_axis != Vector3.ZERO:
		var angle := transform.basis.y.angle_to(ground_normal)
		rotate(rotation_axis.normalized(), angle)
	
	rotate(transform.basis.y, steer)
	
	var velocity := global_transform.basis.z * speed * delta
	global_transform.origin = ground_position + velocity
	
	update_animation(delta)


func _physics_process(_delta: float) -> void:
	if ground_ray.is_colliding():
		ground_position = ground_ray.get_collision_point()
		ground_normal = ground_ray.get_collision_normal() * normal_smooth + (1 - normal_smooth) * ground_normal
		ground_normal = ground_normal.normalized()


func update_animation(delta : float) -> void:
	var is_tilting := steer != 0 and (sign(steer) == sign(tilt) or tilt == 0)
	t_tilt = clamp(t_tilt + delta / (tilt_duration if is_tilting else -tilt_duration), 0, 1)
	
	var tilt_dir := sign(steer) if is_tilting else sign(tilt)
	tilt = lerp(0, max_tilt, t_tilt) * tilt_dir
	graph.rotation.z = deg2rad(tilt)
	graph.rotation.y = deg2rad(tilt / max_tilt * max_yaw)
	
	animation_tree.set("parameters/Tilt/blend_position", tilt / max_tilt)
	animation_tree.set("parameters/Acceleration/blend_position", t_speed)


func _on_HitBox_area_entered(_area: Area) -> void:
	is_dead = true
	$Graph.visible = false
	var particles : Particles = $Particles
	particles.emitting = true
	
	yield(get_tree().create_timer(particles.lifetime + 0.5), "timeout")
	
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menu/GameOverScreen.tscn")
