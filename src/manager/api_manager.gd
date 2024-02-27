class_name ApiManager
extends Node

@export var http_request: HTTPRequest

signal objects_loaded
signal detailed_info_loaded

class NeowResponse:
	var count
	var near_earth_objects: Array[BasicNeowObject]


class BasicNeowObject:
	var link: String
	var id: String
	var name: String
	var diameter




# Called when the node enters the scene tree for the first time.
func _ready():
	Events.object_selected.connect(_on_object_selected)

	%ListRequest.request_completed.connect(_on_list_request_completed)
	%DetailedInfoRequest.request_completed.connect(_on_detailed_info_completed)
	request_data()


func request_data():
	%ListRequest.request("https://api.nasa.gov/neo/rest/v1/feed?api_key=" + Config.new().api_key)


func _on_object_selected(object: BasicNeowObject):
	%DetailedInfoRequest.request(object.link)

func _on_list_request_completed(_result, _response_code, _headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json["element_count"])
	var output = NeowResponse.new()
	output.count = json["element_count"]
	var objects_in_dates = json["near_earth_objects"]
	var output_objects : Array[BasicNeowObject] = []
	for date in objects_in_dates.keys():
		for object in objects_in_dates[date]:
			var temp = BasicNeowObject.new()
			temp.name = object["name"]
			temp.link = object["links"]["self"]
			temp.id = object["id"]
			temp.diameter = {
				"min": object["estimated_diameter"]["meters"]["estimated_diameter_min"],
				"max": object["estimated_diameter"]["meters"]["estimated_diameter_max"]
			}
			output_objects.push_back(temp)
	print(output_objects)
	output.near_earth_objects = output_objects
	print(output)
	Events.emit_objects_loaded(output)
	# output.near_earth_objects

func _on_detailed_info_completed(_result, _response_code, _headers, body):
	print(body)
	var neow_object_json = JSON.parse_string(body.get_string_from_utf8())
	var neow_object = NeowObject.new()
	for i in neow_object_json.keys():
		if i == "orbital_data":
			var new_orbit_data = NeowObject.OrbitData.new()
			for j in neow_object_json[i].keys():
				new_orbit_data.set(j, neow_object_json[i][j])
			neow_object.set(i, new_orbit_data)
			continue
		neow_object.set(i, neow_object_json[i])
	detailed_info_loaded.emit(neow_object)

