extends Node


signal start_date_changed
signal end_date_changed

signal objects_loaded

func emit_start_date_changed(date: int):
	start_date_changed.emit(date)

func emit_end_date_changed(date: int):
	end_date_changed.emit(date)

func emit_objects_loaded(data: NeowObject.NeowResponse):
	objects_loaded.emit(data)