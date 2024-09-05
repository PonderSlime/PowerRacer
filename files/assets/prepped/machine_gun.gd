extends Node3D

@export var raycast : RayCast3D
@export var damage = 10
@onready var b_decal = preload("res://assets/prepped/projectile/impact.tscn")
@export var anim_player : AnimationPlayer
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	fire()

func fire():
	if Input.is_action_pressed("fire_1"):
		if not anim_player.is_playing():
			print("fired a shot")
			
			if raycast.is_colliding():
				var target = raycast.get_collider()
		anim_player.play("MachineGun")
		MovementStates.is_firing = true
		
	else:
		anim_player.stop()
		MovementStates.is_firing = false
