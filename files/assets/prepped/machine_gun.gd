extends Node3D

@export var raycast : RayCast3D
@export var damage = 10
@onready var b_decal = preload("res://assets/prepped/projectile/impact.tscn")
@export var anim_player : AnimationPlayer

signal weapon_fired

func _physics_process(delta: float) -> void:
	fire()

func fire():
	if Input.is_action_pressed("fire_1"):
		weapon_fired.emit()
		await get_tree().create_timer(0.5).timeout
		#if not anim_player.is_playing():
		print("fired a shot")
		weapon_fired.emit()
		if raycast.is_colliding():
			var target = raycast.get_collider()
			var b = b_decal.instantiate()
			target.add_child(b)
			b.global_transform.origin = raycast.get_collision_point()
			b.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
		anim_player.play("MachineGun")
		MovementStates.is_firing = true
		
	else:
		anim_player.stop()
		MovementStates.is_firing = false
