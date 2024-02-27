extends PanelContainer

var object_list: ItemList


func _ready():
	object_list = %ObjectList
	object_list.item_selected.connect(_on_item_selected)
	Events.objects_loaded.connect(_on_items_loaded)

func add_items(items: Array[ApiManager.BasicNeowObject]):
	object_list.clear()
	for item in items:
		object_list.add_item(item.name)


func _on_items_loaded(response: ApiManager.NeowResponse):
	print(response)
	add_items(response.near_earth_objects)


func _on_item_selected(index: int):
	print(index)
