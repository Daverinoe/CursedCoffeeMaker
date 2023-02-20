extends MeshInstance3D
class_name Floor

enum FLOOR_TYPES {
	CARPET = 0,
	WOOD = 1,
	TILE = 2,
	DIRT = 3,
}

var floor_dict : Dictionary = {
	0: "carpet",
	1: "wood",
	2: "tile",
	3: "dirt",
}

@export_enum("Carpet", "Wood", "Tile", "Dirt") var floor_type : int = FLOOR_TYPES.CARPET


func set_floor_type() -> void:
	if GlobalRefs.current_floor != floor_dict[floor_type]:
		GlobalRefs.current_floor = floor_dict[floor_type]
		Event.emit_signal("change_floor")
