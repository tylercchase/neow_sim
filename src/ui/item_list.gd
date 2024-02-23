extends PanelContainer

var object_list : ItemList
# Called when the node enters the scene tree for the first time.
func _ready():
	object_list = %ObjectList
	object_list.item_selected.connect(_on_item_selected)


func _on_item_selected(index: int):
	print(index)