extends Control

# Enums
enum PushDirection {LEFT, RIGHT, DOWN, UP}

# Consts
const bp = Vector2(164, 96)

# Preloads
onready var tileNode = preload("res://scenes/elements/tile.tscn")

# Mouse Stuff
var validMousePosition = false
var pushDirection = PushDirection.LEFT
var firstBlock = Vector2(0,0)
var pushRow = -1

# Game States
var board = []


func _ready():
	randomize()
	populate()


func _input(event):
	if event is InputEventMouseButton:
		processClick()
	elif event is InputEventMouseMotion:
		$mouse.set_text(str(event.position))
		var coords = worldToMap(event.position)
		$debug.set_text(str(coords))
		validMousePosition = checkValidPosition(coords)

		if validMousePosition:
			$tile.position = Vector2(64, 32) * coords + bp

func processClick():
	print("click")


func worldToMap(pos):
	var vector = (Vector2(int(pos.x), int(pos.y)) - Vector2(164, 96)) / Vector2(64, 32)
	var coords = Vector2(int(vector.x), int(vector.y))
	
	# Extend boundaries
	if vector.x < 0:
		coords.x = -1
	if vector.y < 0:
		coords.y = -1
	
	return coords


func checkValidPosition(coords):
	var valid = false

	if coords.x == -1 and coords.y >= 0 and coords.y < 5:
		pushDirection = PushDirection.RIGHT
		pushRow = coords.y
		firstBlock = Vector2(0, pushRow)
		valid = true
	elif coords.x == 5 and coords.y >= 0 and coords.y < 5:
		pushDirection = PushDirection.LEFT
		pushRow = coords.y
		firstBlock = Vector2(4, pushRow)
		valid = true
	elif coords.y == -1 and coords.x >= 0 and coords.x < 5:
		pushDirection = PushDirection.DOWN
		pushRow = coords.x
		firstBlock = Vector2(pushRow, 0)
		valid = true
	elif coords.y == 5 and coords.x >= 0 and coords.x < 5:
		pushDirection = PushDirection.UP
		pushRow = coords.x
		firstBlock = Vector2(pushRow, 4)
		valid = true
	return valid


func _on_Button_button_up():
	Global.fullscreen()


func _on_clickDelay_timeout():
	pass # Replace with function body.


func populate():
	for y in range(0, 5):
		var row = []
		for x in range(0, 5):
			var instance = tileNode.instance()
			var color = randi()%3
			var power = randi()%2
			instance.setup(color, power)
			instance.position = bp + Vector2(x * 64, y * 32)
			$platform/tiles.add_child(instance)
			row.append(instance)
		board.append(row)
	
	print(board)