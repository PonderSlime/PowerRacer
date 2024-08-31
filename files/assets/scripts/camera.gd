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
	
func _physics_process(delta: float) -> void:
	global_position = cam_root.global_position
	$origin.global_rotation.y = lerp_angle($origin.global_rotation.y, car.global_rotation.y, delta * 2)
	if is_captured == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif is_captured == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#if !player.is_on_floor() and Input.is_action_just_pressed("glide"):
		#if is_gliding:
			#is_gliding = false
			#print("glide off")
		#else:
			#if !is_gliding:
				#is_gliding = true
				#print("glide on")
	#else:
		#if player.is_on_floor():
			#is_gliding = false
			
		#if tween:
			#tween.kill()
	#
		#tween = create_tween()
		#if !is_gliding:
			#tween.tween_property(camera, "fov", camera_fov, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		#else:
			#tween.tween_property(camera, "fov", 85, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#

#func _on_set_movement_state(_movement_state : MovementState):
	#camera_fov = _movement_state.camera_fov
