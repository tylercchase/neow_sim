@tool
extends Node3D


var test: NeowObject

func _ready():
	test_object()



func test_object():
	var neow_object_json = load("res://src/manager/neow_object.json").get_data()
	var neow_object = NeowObject.new()
	for i in neow_object_json.keys():
		print(i)
		if i == 'orbital_data':
			var new_orbit_data = NeowObject.OrbitData.new()
			for j in neow_object_json[i].keys():
				new_orbit_data.set(j, neow_object_json[i][j])
			neow_object.set(i, new_orbit_data)
			continue
		neow_object.set(i, neow_object_json[i])
	print(neow_object)
	test = neow_object
