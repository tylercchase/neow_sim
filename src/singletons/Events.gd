extends Node

signal start_date_changed
signal end_date_changed

signal objects_loaded
signal object_selected


func emit_start_date_changed(date: int):
	start_date_changed.emit(date)


func emit_end_date_changed(date: int):
	end_date_changed.emit(date)


func emit_objects_loaded(data: ApiManager.NeowResponse):
	objects_loaded.emit(data)


func emit_object_selected(data: ApiManager.BasicNeowObject):
	object_selected.emit(data)
