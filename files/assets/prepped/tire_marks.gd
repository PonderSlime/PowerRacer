extends MeshInstance3D

# script by thomason1005 to create tire marks on a vehiclewheel
# this is meant to be attached to a MeshInstance3D which is not a child of the VehicleBody, so in global space.
# the mesh can be left empty, as it will be overriden each frame
# one of these is needed for each wheel, apply any material you want to it

@export var target:VehicleWheel3D # the tire we are making tire marks for
@export var skidLimit:float = .7 # the limit at which we start creating tire marks

var vertices = PackedVector3Array()
#var UVs = PackedVector2Array()
var max_length = 3*100 # should be a multiple of 6, as we write 6 each frame
var i = 0 # this is used to loop through the vertices array
var min_dist = .5 # after this distance, we will create new vertices

var lastStart = Vector3.ZERO

@onready var b_decal = preload("res://assets/prepped/player/TreadDecal.tscn")
var hasGap = false # if the tire track has been interrupted
	
func _process(delta):
	var pos = (target.global_position - global_position) - Vector3(0,.25,0)
	
	var skidding = target.is_in_contact() and target.get_skidinfo() < skidLimit #or use target.wheel_friction_slip
	
	# make a new tire mark if we are above the threshold distance
	if (pos-lastStart).length() > min_dist:
		#only make skidmarks if wheels are below treshold
		if skidding:
			if i >= max_length-6:
				i = 0
			var b = b_decal.instantiate()
			get_parent().add_child(b)
			b.global_transform.origin = target.global_transform.origin
			b.global_position.y -= 0.29
			b.global_rotation.x = target.get_parent().global_rotation.x
			b.global_rotation.y = target.global_rotation.y
			b.global_rotation.z = target.get_parent().global_rotation.z
		
		hasGap = not skidding
		if target.wheel_friction_slip == 2 and target.is_in_contact():
			var b = b_decal.instantiate()
			get_parent().add_child(b)
			b.global_transform.origin = target.global_transform.origin
			b.global_position.y -= 0.29
			b.global_rotation.x = target.get_parent().global_rotation.x
			b.global_rotation.y = target.global_rotation.y
			b.global_rotation.z = target.get_parent().global_rotation.z
	# extend the old tire mark if we are below the treshold
	else:
		if skidding and not hasGap:
			
			var lastI = (i-6)
			if lastI < 0:
				lastI += max_length
			var b = b_decal.instantiate()
			get_parent().add_child(b)
			b.global_transform.origin = target.global_transform.origin
			b.global_position.y -= 0.29
			b.global_rotation.x = target.get_parent().global_rotation.x
			b.global_rotation.y = target.global_rotation.y
			b.global_rotation.z = target.get_parent().global_rotation.z
