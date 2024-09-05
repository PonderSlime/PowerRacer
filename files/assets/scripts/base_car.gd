extends VehicleBody3D
class_name BaseCar

@export var STEER_SPEED = 1.5 / 2
@export var STEER_LIMIT = 0.6
var steer_target = 0
@export var engine_force_value_default = 80#40
@onready var engine_force_value = engine_force_value_default#40

var fwd_mps : float
var speed: float
var tread : bool = false
var falling : bool = false
var on_floor : bool = false
var flip : bool = false
@onready var b_decal = preload("res://assets/prepped/player/TreadDecal.tscn")
func _ready():
	#%CarResetter.init()
	pass

func addTireTracks():
	if $rear_left_tire.is_in_contact():
		var b = b_decal.instantiate()
		get_parent().add_child(b)
		b.global_transform.origin = $rear_left_tire.global_transform.origin
		b.global_position.y -= 0.29
		var r = get_rotation()
		b.set_rotation(r)
	if $rear_right_tire.is_in_contact():
		var b = b_decal.instantiate()
		get_parent().add_child(b)
		b.global_transform.origin = $rear_right_tire.global_transform.origin
		b.global_position.y -= 0.29
		var r = get_rotation()
		b.set_rotation(r)
	#wdd
	
func _physics_process(delta):
	speed = linear_velocity.length()*Engine.get_frames_per_second()*delta
	fwd_mps = transform.basis.x.x
	traction(speed)
	process_accel(delta)
	process_steer(delta)
	process_brake(delta)
	if $rear_left_tire.is_in_contact() == false:
		falling = true
	elif $rear_left_tire.is_in_contact():
		falling = false
	if falling == true:
		tread = true
		await get_tree().create_timer(4).timeout
		tread = false
	#if falling == false:
	#if on_floor:
	if get_contact_count() > 0 or $rear_left_tire.is_in_contact() == true:
		if Input.is_action_just_pressed("hop"):
			linear_velocity.y += 10
	if tread:
		addTireTracks()
		
	if falling == true:
		if Input.is_action_pressed("brake"):
			angular_velocity.z = 0
			print("brake")
	#%Hud/speed.text=str(round(speed*3.8))+"  KMPH"
	#print(str(round(speed*3.8))+"  KMPH")

func process_accel(delta):
	if speed > 5:
		MovementStates.state = MovementStates.States.DRIVING
		if MovementStates.speeding:
			MovementStates.state = MovementStates.States.SPEEDING
	elif speed < 5:
		MovementStates.state = MovementStates.States.IDLE
	if Input.is_action_pressed("speed"):
		engine_force_value = engine_force_value_default * 4
		MovementStates.speeding = true
	else:
		engine_force_value = engine_force_value_default
		MovementStates.speeding = false
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
		tread = true
	if Input.is_action_just_released("brake"):
		tread = false
	else:
		$rear_left_tire.wheel_friction_slip=2.9
		$rear_right_tire.wheel_friction_slip=2.9


func traction(speed):
	apply_central_force(Vector3.DOWN*speed)
