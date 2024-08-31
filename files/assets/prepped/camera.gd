extends Node3D
# Origin rotates along y-axis for revolving motion
# Pivot rotates along x-axis for up/down motion
# Mouse captured is required, so pressing 'esc' will capture mouse
@export var cam_pos : Node3D
func _input(event):
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouse_delta = event.relative
		$origin.rotate_y(deg_to_rad(-mouse_delta.x * 0.2))
		$origin/pivot.rotate_x(deg_to_rad(mouse_delta.y * 0.2))
func _physics_process(delta: float) -> void:
		global_position = cam_pos.global_position
