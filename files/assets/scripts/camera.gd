extends Node3D

@onready var spring_arm = $CamYaw/CamPitch/SpringArm3D
@onready var camera = $CamYaw/CamPitch/SpringArm3D/Camera3D
@export var cam_root : CollisionShape3D
@export var car : VehicleBody3D

var tween : Tween
var is_captured : bool
var camera_fov : float

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		is_captured = !is_captured
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouse_delta = event.relative
		$origin/pivot.rotate_y(deg_to_rad(-event.relative.x * 0.2))
		$origin/pivot.rotation.y = clampf($origin/pivot.rotation.y, -deg_to_rad(25), deg_to_rad(25))
	
func _physics_process(delta: float) -> void:
	global_position = cam_root.global_position
	$origin.global_rotation.y = lerp_angle($origin.global_rotation.y, car.global_rotation.y, delta * 2)
	if is_captured == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif is_captured == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$origin/pivot/SpringArm3D/Camera3D.fov = lerp($origin/pivot/SpringArm3D/Camera3D.fov, MovementStates.cam_fov, delta * 4)
