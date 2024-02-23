extends Node3D

@export var neow_manager: NeowManager
@export var kepler_data: KeplerElements

func _process(delta):
	var coords = neow_manager.keplerian_to_cartesian_with_elements(kepler_data)
	# print(coords)
	global_position = coords