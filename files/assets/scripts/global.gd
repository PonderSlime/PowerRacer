extends Node

enum States {IDLE, DRIVING, SPEEDING, STOP}
var state : States = States.IDLE
var cam_fov : float = 75
var speeding
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if state == States.IDLE:
		cam_fov = lerp(cam_fov, 75., delta * 4)
	elif state == States.DRIVING:
		cam_fov = lerp(cam_fov, 110., delta * 4)
	elif state == States.SPEEDING:
		cam_fov = lerp(cam_fov, 95., delta * 4)
