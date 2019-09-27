extends Control

# Preloads
onready var tileNode = preload("res://scenes/elements/tile.tscn")

# Mouse Stuff
var validMousePosition = false

# Game States
var board = []


func _ready():
	randomize()
	populate()


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

func _on_Button_button_up():
	Global.fullscreen()


func _on_clickDelay_timeout():
	pass # Replace with function body.


func populate():
	var bp = Vector2(164, 96)
	for y in range(0, 5):
		var row = []
		for x in range(0, 5):
			var instance = tileNode.instance()
			var color = randi()%3
			var power = randi()%2
			instance.setup(color, power)
			instance.position = Vector2(bp.x + x * 64, bp.y + y * 32)
			$platform/tiles.add_child(instance)
			row.append(instance)
		board.append(row)
	
	print(board)