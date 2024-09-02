extends VehicleBody3D
class_name BaseCar

@export var STEER_SPEED = 1.5 / 2
@export var STEER_LIMIT = 0.6
var steer_target = 0
@export var engine_force_value = 80#40

var fwd_mps : float
var speed: float
var rpm : float
@onready var b_decal = preload("res://assets/prepped/player/TreadDecal.tscn")
func _ready():
	#%CarResetter.init()
	pass

func addTireTracks():
	if $rear_left_tire.is_in_contact():
		var b = b_decal.instantiate()
		get_parent().add_child(b)
		b.global_transform.origin = $rear_left_tire.global_transform.origin
		b.global_position.y -= 0.2
		var r = get_rotation()
		b.set_rotation(r)
	if $rear_right_tire.is_in_contact():
		var b = b_decal.instantiate()
		get_parent().add_child(b)
		b.global_transform.origin = $rear_right_tire.global_transform.origin
		b.global_position.y -= 0.2
		var r = get_rotation()
		b.set_rotation(r)
	if $front_left_tire.is_in_contact():
		var b = b_decal.instantiate()
		get_parent().add_child(b)
		b.global_transform.origin = $front_left_tire.global_transform.origin
		b.global_position.y -= 0.2
		var r = get_rotation()
		b.set_rotation(r)
	if $front_right_tire.is_in_contact():
		var b = b_decal.instantiate()
		get_parent().add_child(b)
		b.global_transform.origin = $front_right_tire.global_transform.origin
		b.global_position.y -= 0.2
		var r = get_rotation()
		b.set_rotation(r)
	
func _physics_process(delta):
	
	speed = linear_velocity.length()*Engine.get_frames_per_second()*delta
	fwd_mps = transform.basis.x.x
	traction(speed)
	process_accel(delta)
	process_steer(delta)
	process_brake(delta)
	addTireTracks()
	#print(rpm)
	#print($rear_left_tire.rotation_degrees.x)
	#%Hud/speed.text=str(round(speed*3.8))+"  KMPH"

func process_accel(delta):
	if speed > 5:
		MovementStates.state = MovementStates.States.DRIVING
	elif speed < 5:
		MovementStates.state = MovementStates.States.IDLE
	if Input.is_action_pressed("back"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		if fwd_mps >= -1:
			if speed < 30 and speed != 0:
				engine_force = clamp(engine_force_value * 10 / speed, 0, 300)
			else:
				engine_force = engine_force_value
		return
	
	if Input.is_action_pressed("forward"):
	# Increase engine force at low speeds to make the initial acceleration faster.
		if speed < 20 and speed != 0:
			engine_force = -clamp(engine_force_value * 3 / speed, 0, 300)
		else:
			engine_force = -engine_force_value
		return
	
	engine_force = 0
	brake = 0

func process_steer(delta):
	steer_target = Input.get_action_strength("left") - Input.get_action_strength("right")
	steer_target *= STEER_LIMIT
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)

func process_brake(delta):
	if Input.is_action_pressed("brake"):
		brake=0.5
		$rear_left_tire.wheel_friction_slip=2
		$rear_right_tire.wheel_friction_slip=2
	else:
		$rear_left_tire.wheel_friction_slip=2.9
		$rear_right_tire.wheel_friction_slip=2.9


func traction(speed):
	apply_central_force(Vector3.DOWN*speed)
