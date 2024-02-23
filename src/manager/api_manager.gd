extends Node

@export var http_request: HTTPRequest

signal objects_loaded





# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request("https://api.nasa.gov/neo/rest/v1/feed?api_key=" + Config.new().api_key)


func _on_request_completed(_result, _response_code, _headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json["element_count"])
	var output = NeowObject.NeowResponse.new()
	output.count = json["element_count"]
	var objects_in_dates = json["near_earth_objects"]
	var output_objects := []
	for date in objects_in_dates.keys():
		for object in objects_in_dates[date]:
			var temp = NeowObject.BasicNeowObject.new()
			temp.link = object["links"]["self"]
			temp.id = object["links"]["self"]
			temp.diameter = {
				"min": object["estimated_diameter"]["meters"]["estimated_diameter_min"],
				"max": object["estimated_diameter"]["meters"]["estimated_diameter_max"]
			}
			output_objects.push_back(temp)
	print(output_objects)
	output.near_earth_objects = output_objects
	print(output)
	# output.near_earth_objects
