extends VehicleBody

var max_rpm = 10000
var max_torque = 100000
export var camera_distance_x = 1
export var camera_distance_y = 2
export var camera_smooth = 0.5
export var mod = 5
export var camera_org = Vector3(0, 9, -20)
export var target_org = Vector3(0, 9, 0)
export var camera_mov_steering = Vector3(10, 0, 0)

onready var camera = $camera
onready var target = $target
onready var camera_pos = $camera.transform.origin
onready var target_pos = $target.transform.origin

func camera_translate(position : Vector3, delta):
	return $camera.transform.origin.linear_interpolate(position, delta * camera_smooth)

func focus_translate(position: Vector3, delta):
	return $target.transform.origin.linear_interpolate(Vector3(position), delta * camera_smooth)

func camera_pan(camera, target):
	look_at_from_position(camera, target, Vector3.UP)
	
func _physics_process(delta):
	steering = lerp(steering, Input.get_axis("right", "left") * 0.4, 5 * delta)
	var acceleration = Input.get_axis("back", "forward")
	
	var rpm
	rpm = $back_left_wheel.get_rpm()
	$back_left_wheel.engine_force = acceleration * max_torque * (1 - abs(rpm) / max_rpm)
	rpm = $back_right_wheel.get_rpm()
	$back_right_wheel.engine_force = acceleration * max_torque * (1 - abs(rpm) / max_rpm)

	if acceleration > 0.1 && rpm > 0:
		$camera.transform.origin = $camera.transform.origin.linear_interpolate(Vector3(0, 10, -15), delta * camera_smooth)		
#		camera_pos = camera_translate(Vector3(0, 15, -25), delta * camera_smooth)
	elif acceleration < 0.1 && rpm > 0:
		$camera.transform.origin = $camera.transform.origin.linear_interpolate(Vector3(0, 10, -15), delta * camera_smooth)
#		camera_pos = camera_translate(Vector3(0, 10, -15), delta * camera_smooth)
	elif acceleration > 0.1 && rpm < 0:
		$camera.transform.origin = $camera.transform.origin.linear_interpolate(Vector3(0, 10, 15), delta * camera_smooth)
#		camera_pos = camera_translate(Vector3(0, 10, 15), delta * camera_smooth)
	elif acceleration < 0.1 && rpm < 0:
		$camera.transform.origin = $camera.transform.origin.linear_interpolate(Vector3(0, 10, 20), delta * camera_smooth)
#		camera_pos = camera_translate(Vector3(0, 10, 20), delta * camera_smooth)
	else:
		$camera.transform.origin = $camera.transform.origin.linear_interpolate(camera_org, delta * camera_smooth)

	if steering > 0.1:
		if $target.transform.origin.x <= 3:
			$target.transform.origin = $target.transform.origin.linear_interpolate(camera_pos + camera_mov_steering, delta * camera_smooth)
		if $camera.transform.origin.x <= 5:
			$camera.transform.origin = $camera.transform.origin.linear_interpolate(camera_pos + camera_mov_steering, delta * camera_smooth)
	elif steering < -0.1:
		if $target.transform.origin.x >= -3:
			$target.transform.origin = $target.transform.origin.linear_interpolate(camera_pos - camera_mov_steering, delta * camera_smooth)
		if $camera.transform.origin.x >= -5:
			$camera.transform.origin = $camera.transform.origin.linear_interpolate(camera_pos - camera_mov_steering, delta * camera_smooth)
	else:
		$target.transform.origin = $target.transform.origin.linear_interpolate(Vector3(target_org), delta * camera_smooth * 2)
		$camera.transform.origin = $camera.transform.origin.linear_interpolate(Vector3(camera_org), delta * camera_smooth * 2)
	
#	camera_pan($camera.transform.origin, $target.transform.origin)
#	look_at_from_position($camera.transform.origin, $target.transform.origin, Vector3.UP)
	
	print(steering)
	
#	if acceleration > 0.1 && rpm > 0: #acelerando y velocidad positiva
#		camera_steer(steering, mod, delta)
#		$target.transform.origin = $target.transform.origin.linear_interpolate(Vector3(0, camera_distance_y, max_camera_distance_z), delta * camera_smooth)
#	elif acceleration < -0.1 && rpm > 0: #frenando y velocidad positiva
#		camera_steer(steering, mod, delta)
#		$target.transform.origin = $target.transform.origin.linear_interpolate(Vector3(0, camera_distance_y, rest_camera_distance_z), delta * camera_smooth)		
#	elif acceleration < -0.1 && rpm < 0:
#		camera_steer(steering, mod, delta)
#		$target.transform.origin = $target.transform.origin.linear_interpolate(Vector3(0, camera_distance_y, -max_camera_distance_z + 1), delta * camera_smooth)
#	else:
#		camera_steer(steering, 0, delta)
#		$target.transform.origin = $target.transform.origin.linear_interpolate(Vector3.ZERO, delta * 1)
#
#func camera_steer(steering, mod, delta):
#	if steering > 0.1:
#		$target.transform.origin = $target.transform.origin.linear_interpolate(Vector3(camera_distance_x + mod, 0, 0), delta * camera_smooth)
#		$camera.transform.origin = $camera.transform.origin.linear_interpolate(Vector3(2, 5, -7), delta * camera_smooth)
#	elif steering < -0.1:
#		$target.transform.origin = $target.transform.origin.linear_interpolate(Vector3(-camera_distance_x - mod, 0, 0), delta * camera_smooth)
#		$camera.transform.origin = $camera.transform.origin.linear_interpolate(Vector3(-2, 5, -7), delta * camera_smooth)
#	else:
#		$target.transform.origin = $target.transform.origin.linear_interpolate(Vector3.ZERO, delta * 1)
#		$camera.transform.origin = $camera.transform.origin.linear_interpolate(Vector3(0, 5, -7), delta * 1 / camera_smooth)
