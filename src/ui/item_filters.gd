extends PanelContainer

var start_date_label: Label
var start_date_slider: HSlider
var end_date_label: Label
var end_date_slider: HSlider
# Called when the node enters the scene tree for the first time.
func _ready():
	start_date_label = %StartDateLabel
	start_date_slider = %StartDateSlider
	end_date_label = %EndDateLabel
	end_date_slider = %EndDateSlider


func _on_slider_value_changed(value: float):
	pass
