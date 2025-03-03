class_name TownManager
extends Node
## Manages the town state

var tiles : Array[Tile] # Contains the town tiles
var rng = RandomNumberGenerator.new()
var building : bool = false
const BUILD_TIME: float = 5.0 # The number of seconds between attempting to build a new building

var housing_buildings: Array[Tile.Type] = [Tile.Type.HOUSE]
var refinery_buildings: Array[Tile.Type] = [Tile.Type.WINDMILL]
var harvester_buildings: Array[Tile.Type] = [Tile.Type.FARMHOUSE]
var storage_buildings: Array[Tile.Type] = [Tile.Type.HOLLOW_TREE]


# town expansion

## Checks whether the town can expand. Add conditions as necessary.
func can_expand() -> bool:
	if tiles.size() == 0: return false
	else: return true


## Checks whether a building can be built on a given tile.
func is_buildable(tile : Tile) -> bool:
	if Tile.has_tag(tile, "terrain"): return true
	else: return false
	
	
## Returns a random tile onto which the town can expand
func get_built_tile() -> Tile:
	var outer_buildings: Array[Tile] = tiles.filter(
			func(t1: Tile): return t1.get_neighbors().any(
				func(t2: Tile): return is_buildable(t2)
			)
		)
	var build_from: Tile = outer_buildings.pick_random()
	var build_to: Tile = build_from.get_neighbors().filter(is_buildable).pick_random()
	return build_to


## Chooses a building to build on the selected tile and constructs it 	
func build_on(tile : Tile) -> Tile.Type:
	var weights: Array[int] = [2, 1, 1, 1]
	var building_types = ["Housing", "Refinery", "Harvester", "Storage"]
	var new_building_type : Tile.Type
	match building_types[rng.rand_weighted(weights)]:
		"Housing": new_building_type = housing_buildings.pick_random()
		"Refinery": new_building_type = refinery_buildings.pick_random()
		"Harvester": new_building_type = harvester_buildings.pick_random()
		"Storage": new_building_type = storage_buildings.pick_random()
	tile.type = new_building_type		
	return new_building_type

	
## Initiates the town expansion
func start_building():
	building = true
	while building:
		var build_timer = get_tree().create_timer(BUILD_TIME)
		await build_timer.timeout
		if can_expand():
			build_on(get_built_tile())
	
		
func stop_building():
	building = false
	
	
# tile tracking

## Starts tracking a tile as part of the town. Only use with town tiles.
func track_tile(tile: Tile) -> void:
	tiles.append(tile)
	

## Stops tracking a tile.
func untrack_tile(tile: Tile) -> void:
	assert(tile in tiles)
	tiles.erase(tile)
	
