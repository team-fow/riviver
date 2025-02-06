extends CanvasLayer

var tile_type: Tile.Type
var prop_type: Prop.Type

@export var tabs: TabContainer
@export var tile_list: ItemList
@export var prop_list: ItemList
@export var coords_label: Label


func _unhandled_input(event: InputEvent) -> void:
	var coords: Vector2i = Game.grid.point_to_coords(Game.grid.get_local_mouse_position())
	
	if Input.is_action_pressed("click"):
		match tabs.current_tab:
			0:
				Game.grid.set_tile(tile_type, coords)
			1:
				var tile: Tile = Game.grid.get_tile(coords)
				if tile: tile.set_prop(prop_type)
	
	if event is InputEventMouseMotion:
		coords_label.text = str(coords)



# list

func _ready() -> void:
	for info: TileInfo in Tile.info:
		tile_list.add_item(info.name, info.icon)
	for info: PropInfo in Prop.info:
		prop_list.add_item(info.name, info.icon)


func _on_tile_selected(idx: int) -> void:
	tile_type = idx as Tile.Type


func _on_prop_selected(idx: int) -> void:
	prop_type = idx as Prop.Type
