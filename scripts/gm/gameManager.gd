extends Control


var validMousePosition = false


func _input(event):
	if event is InputEventMouseButton:
		processClick()
	elif event is InputEventMouseMotion:
		var coords = $TileMap.world_to_map(event.position)
		$mouse.set_text(str(event.position))
		$debug.set_text(str(coords))
		
		validMousePosition = checkValidPosition(coords)
		
		if validMousePosition:
			$tile.position = Vector2(64, 64) * coords


func processClick():
	print("click")


func checkValidPosition(coords):
	pass