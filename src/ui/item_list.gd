extends PanelContainer

var object_list: ItemList

var list_of_objects: Array[ApiManager.BasicNeowObject]

func _ready():
	object_list = %ObjectList
	object_list.item_selected.connect(_on_item_selected)
	Events.objects_loaded.connect(_on_items_loaded)

func add_items(items: Array[ApiManager.BasicNeowObject]):
	object_list.clear()
	list_of_objects = items
	for item in items:
		object_list.add_item(item.name)


func _on_items_loaded(response: ApiManager.NeowResponse):
	print(response)
	add_items(response.near_earth_objects)


func _on_item_selected(index: int):
	print(index)
	Events.emit_object_selected(list_of_objects[index])
