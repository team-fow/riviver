extends TaskChecker


func check_completed(task: TaskInfo) -> bool:
	var tile: Tile = task.tile
	var nearby_tiles: Array[Tile] = tile.behavior.get_radius()
	var nearby_river_tiles: Array[Tile] = []
	for t in nearby_tiles:
		if not nearby_river_tiles.has(t) and Tile.has_tag(t, "river"):
			nearby_river_tiles.append(t)
	print("Water Tiles Nearby: " + str(nearby_river_tiles.size()))
	return nearby_river_tiles.size() >= 5
