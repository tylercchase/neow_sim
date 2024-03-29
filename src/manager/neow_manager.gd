class_name NeowManager
extends Node3D

var AU: float = 149597870700
var MU: float = 1.32712440041e20
var STEP_SIZE: int = 30  #days
var AMOUNT_OF_DAYS: int = 49590
var STEP_AMOUNT: int = AMOUNT_OF_DAYS / STEP_SIZE


@export var api_manager: ApiManager

@export var conversion_factor = 20.0
@export var test_node: Node3D


var current_orbiting_object



func _ready():
	var neow_object_json = load("res://src/manager/neow_object.json").get_data()
	# var output = parse_object_data(neow_object_json)
	# print(output.designation)
	api_manager.detailed_info_loaded.connect(_on_detailed_info_loaded)


func _on_detailed_info_loaded(info: NeowObject):
	if current_orbiting_object:
		current_orbiting_object.queue_free()
	var coords = keplerian_to_cartesian(info)
	test_node.global_position = coords
	# print(info)
	print(coords)



func arctan2(y: float, x: float) -> float:
	if x > 0:
		return atan(y / x)
	if y >= 0 && x < 0:
		return atan(y / x) + PI
	if y < 0 && x < 0:
		return atan(y / x) - PI
	if y > 0 && x == 0:
		return PI / 2
	if y < 0 && x == 0:
		return PI / 2
	printerr("Both X and Y were 0")
	return 0.0


func newton_raphson(eccentric_anomaly, eccentricity, mean_anomaly, step_amount: float):
	var f = 0.0
	var d_f = 0.0
	for x in step_amount:
		f = eccentric_anomaly - mean_anomaly - (eccentricity * sin(eccentric_anomaly))
		d_f = 1.0 - eccentricity * cos(eccentric_anomaly)
		eccentric_anomaly = eccentric_anomaly - (f / d_f)
	return eccentric_anomaly


func calc_algo(body: KeplerElements) -> Vector3:
	var delta_t = 86400.0 * (body.epoch_t - body.epoch_t0);
	body.mean_anomaly = body.mean_anomaly + delta_t * sqrt(MU/ pow(body.semi_major_axis,3))
	if body.mean_anomaly >= 2.0*PI:
		body.mean_anomaly -= 2.0*PI

	body.eccentric_anomaly = newton_raphson(body.mean_anomaly, body.eccentricity, body.mean_anomaly, 50);

	body.true_anomaly = 2.0 * arctan2(sin(sqrt(1.0+body.eccentricity) * (body.eccentric_anomaly/2.0)), sqrt(1.0-body.eccentricity) * cos(body.eccentric_anomaly/2.0))

	var distance_to_central_body: float = body.semi_major_axis*(1 - body.eccentricity * cos(body.eccentric_anomaly));

	var ot: Vector3 = Vector3(distance_to_central_body * cos(body.true_anomaly), distance_to_central_body * sin(body.true_anomaly), 0.0)

	var rt : Vector3 = Vector3(0.0,0.0,0.0)

	rt.x = ot.x * (cos(body.argument_periaps) * cos(body.longitude_ascending_node) - sin(body.argument_periaps) * cos(body.inclination) * sin(body.longitude_ascending_node) - ot.y * (sin(body.argument_periaps)*cos(body.longitude_ascending_node) + cos(body.argument_periaps)* cos(body.inclination) * sin(body.longitude_ascending_node)))
	rt.y = ot.x * (cos(body.argument_periaps) * sin(body.longitude_ascending_node) + sin(body.argument_periaps) * cos(body.inclination) * cos(body.longitude_ascending_node) + ot.y * (cos(body.argument_periaps) * cos(body.inclination)*cos(body.longitude_ascending_node)-sin(body.argument_periaps)*sin(body.longitude_ascending_node)))
	rt.z = ot.x * sin(body.argument_periaps)*sin(body.inclination)+ot.y * cos(body.argument_periaps)*sin(body.inclination);
	return rt

func keplerian_to_cartesian(orbit: NeowObject):
	# print(orbit.orbital_data.eccentricity)

	var kepler_element := KeplerElements.new()
	kepler_element.semi_major_axis = float(orbit.orbital_data.semi_major_axis)
	kepler_element.eccentricity = float(orbit.orbital_data.eccentricity)
	kepler_element.argument_periaps = float(orbit.orbital_data.perihelion_argument)
	kepler_element.longitude_ascending_node = float(orbit.orbital_data.ascending_node_longitude)
	kepler_element.eccentric_anomaly = 0
	kepler_element.inclination = float(orbit.orbital_data.inclination)
	kepler_element.true_anomaly =float(orbit.orbital_data.mean_anomaly)
	kepler_element.mean_anomaly = float(orbit.orbital_data.mean_anomaly)
	kepler_element.epoch_t0 = Time.get_unix_time_from_datetime_string(orbit.orbital_data.first_observation_date)
	kepler_element.epoch_t = Time.get_unix_time_from_datetime_string(orbit.orbital_data.last_observation_date)

	var coords_local := calc_algo(kepler_element)
	var converted_coords = Vector3(coords_local.x*conversion_factor, coords_local.y*conversion_factor, coords_local.z*conversion_factor)
	return converted_coords

func keplerian_to_cartesian_with_elements(kepler_element: KeplerElements) -> Vector3:
	var thing = kepler_element.duplicate()
	var coords_local := calc_algo(thing)
	var converted_coords = Vector3(coords_local.x*conversion_factor, coords_local.y*conversion_factor, coords_local.z*conversion_factor)
	return converted_coords
	