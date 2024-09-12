extends Node3D

@export var weapon : Node3D
@export var flash_time : float = 0.1334

@export var light : OmniLight3D
@export var emitter : GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapon.weapon_fired.connect(add_muzzle_flash)

func add_muzzle_flash():
	light.visible = true
	emitter.emitting = true
	await get_tree().create_timer(flash_time).timeout
	light.visible = false    
	emitter.emitting = false                                                                                                
