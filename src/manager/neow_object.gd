class_name NeowObject
extends Resource


class OrbitData:
	var orbit_id: String
	var orbit_determination_date: String
	var first_observation_date: String
	var last_observation_date: String
	var data_arc_in_days: int
	var observations_used: int
	var orbit_uncertainty: String
	var minimum_orbit_intersection: String
	var jupiter_tisserand_invariant: String
	var epoch_osculation: String
	var eccentricity: String
	var semi_major_axis: String
	var inclination: String
	var ascending_node_longitude: String
	var orbital_period: String
	var perihelion_distance: String
	var perihelion_argument: String
	var aphelion_distance: String
	var perihelion_time: String
	var mean_anomaly: String
	var mean_motion: String
	var equinox: String


var id: String
var neo_reference_id: String
var name: String
var designation: String
var nasa_jpl_url: String
var absolute_magnitude_h: float
var is_postentially_hazardous_asteroid: bool
var is_sentry_object: bool
var orbital_data: OrbitData

