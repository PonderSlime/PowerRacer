extends Node3D

@export var parent : VehicleWheel3D
func _physics_process(delta: float) -> void:
	global_position = parent.global_position
	global_rotation.y = parent.global_rotation.y
