extends CPUParticles3D

var base_height : float = 0.8


func _ready() -> void:
	Event.connect("start_day", change_day)


func change_day() -> void:
	var current_mesh : SphereMesh = self.mesh
	current_mesh.height = base_height * VariableManager.machine_scale.x
	
	if GlobalRefs.day == 4:
		current_mesh.height = 2
		current_mesh.radius = 0.2
