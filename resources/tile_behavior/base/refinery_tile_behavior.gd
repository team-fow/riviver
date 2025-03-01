class_name RefineryTileBehavior
extends BuildingTileBehavior

var progress_bar: Node2D


func start_refining() -> void:
	progress_bar = preload("res://scenes/ui/refinery_progress_bar/refinery_progress_bar.tscn").instantiate()
	progress_bar.position = Game.grid.coords_to_point(tile.coords)
	progress_bar.set_duration(tile.get_info().duration)
	progress_bar.looped.connect(refine)
	RenderingServer.canvas_item_set_parent(progress_bar.get_canvas_item(), tile.rid)


func stop_refining() -> void:
	progress_bar.looped.disconnect(refine)
	progress_bar.queue_free()


func refine() -> void:
	var info: RefineryTileInfo = tile.get_info()
	if Game.player.count_material(info.input_material) < info.input_amount:
		stop_refining()
	else:
		Game.player.add_material(info.input_material, -info.input_amount)
		Game.player.hand.add_card(info.output_cards[randi() % info.output_cards.size()])
