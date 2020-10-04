extends MultiMeshInstance

export var span : float
export var randomness : float
var transforms : Array

func _ready():
	_generate_transforms()
	
	for x in range(32):
		for z in range(32):
			var tr = transforms[(x%8) * 8 + (z%8)]
			tr.origin += Vector3(x/8,0,z/8) * 8 * span - Vector3(16, 0, 16) * span
			multimesh.set_instance_transform(x * 32 + z, tr)

func _generate_transforms():
	for x in range(8):
		for y in range(8):
			var rand_x = (randf() - 0.5) * span * randomness
			var rand_y = (randf() - 0.5) * span * randomness
			
			var pos = Vector3(x * span + rand_x, 0, y * span + rand_y)	
			var scale_factor = 2.0 + (randf() - 0.25) * 3
			var basis = Basis(Vector3.UP, randf() * TAU).scaled(Vector3.ONE * scale_factor)
			
			transforms.push_front(Transform(basis, pos))
