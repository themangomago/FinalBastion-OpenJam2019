extends Control

# Enums
enum PushDirection {LEFT, RIGHT, DOWN, UP}

# Consts
const bp = Vector2(164, 96)

# Preloads
onready var tileNode = preload("res://scenes/elements/tile.tscn")

# Mouse Stuff
var validMousePosition = false
var clickReady = true

var pushDirection = PushDirection.LEFT
var firstBlock = Vector2(0,0)
var pushRow = -1

# Game States
var board = []
var turnsLeft = 5
var attackLane = 0
var attackStrength = 8


func _ready():
	randomize()
	populateBoard()
	nextTile()
	getNewTarget()


func getNewTarget():
	attackLane = randi() % 5
	attackStrength += 2
	$attackIndicator.setStrength(attackStrength)
	$attackIndicator.position = Vector2(164, 32) + Vector2(64 * attackLane, 0)
	turnUpdate(true)


func performAttack():
	var firstBlock = Vector2(attackLane, 0)
	var lifes = attackStrength

	# Stop user from doing stuff
	$clickDelay.stop()
	clickReady = false
	
	for step in range(0, 5):
		$attackDelay.start()
		var node = board[firstBlock.y + step][firstBlock.x]
		
		if node.power <= lifes:
			# Destroy nodes :)
			lifes -= node.power
			node.destroy()
			var instance = spawnNewTile(firstBlock + Vector2(0,step))
			board[firstBlock.y + step][firstBlock.x] = instance
		else:
			# Quit loop
			lifes -= node.power
			break
		$attackIndicator.setStrength(lifes)
		yield($attackDelay, "timeout")
	getNewTarget()
	
	if lifes > 0:
		$hud.killHumans(max(lifes, 0))
		$playerHitAnimation.play("hit")
	$hud.saveHumans()
	
	# Let user do stuff
	clickReady = true


func thisIsTheEndTrigger():
	print("THIS IS THE END MY FRIEND")


func nextTile():
	var color = randi()%3
	var power = randi()%2
	$platform/tile.setup(color, power)


func turnUpdate(reset = false):
	if reset:
		turnsLeft = 5 + 1
	turnsLeft -= 1
	$hud.updateTurns(turnsLeft)
	
	$attackIndicator.setTurn(turnsLeft)
	
	if turnsLeft == 0:
		performAttack()


func _input(event):
	if event is InputEventMouseButton:
		inputProcessClick()
	elif event is InputEventMouseMotion:
		$mouse.set_text(str(event.position))
		var coords = worldToMap(event.position)
		$debug.set_text(str(coords))
		validMousePosition = inputCheckBuildPosition(coords)

		if validMousePosition:
			$platform/tile.position = Vector2(64, 32) * coords + bp


func inputProcessClick():
	if validMousePosition and clickReady:
		clickReady = false
		$clickDelay.start()
		var mergeableFound = -1
		var nextTile
		var curTile = tileNode.instance()
		curTile.setup($platform/tile.color, $platform/tile.power - 1)
		curTile.position = $platform/tile.position
		$platform/tiles.add_child(curTile)

		for step in range(0, 5):
			nextTile = dbGetNextTile(step)
			#print(nextTile)
			
			# Look for mergeables
			if nextTile.node.color == curTile.color and \
				nextTile.node.power == curTile.power:
				nextTile.node.upgrade()
				mergeableFound = step
				curTile.move(nextTile.node.position, Global.TileAfterLife.Die)
				break

			# Remove Current from DB
			board[nextTile.db.y][nextTile.db.x] = curTile
			curTile.move(nextTile.node.position)

			curTile = nextTile.node

		if mergeableFound == -1:
			#print("not found")
			curTile.move(getOffGridPosition(curTile.position), Global.TileAfterLife.Explode)
		#else:
			#print("found @ pos: " + str(mergeableFound))

		nextTile()
		turnUpdate()
#		print("Board:")
#		print(board)
#		print("Childs: "+ str($platform/tiles.get_child_count()))


func inputCheckBuildPosition(coords):
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


func dbGetNextTile(step):
	var dbPosition = Vector2(0, 0)
	var node = null
	
	match pushDirection:
		PushDirection.LEFT:
			dbPosition = Vector2(firstBlock.x - step, firstBlock.y)
		PushDirection.RIGHT:
			dbPosition = Vector2(firstBlock.x + step, firstBlock.y)
		PushDirection.UP:
			dbPosition = Vector2(firstBlock.x, firstBlock.y - step)
		_:
			dbPosition = Vector2(firstBlock.x, firstBlock.y + step)
	
	node = board[dbPosition.y][dbPosition.x]
	return {"node": node, "db": dbPosition}


func worldToMap(pos):
	var vector = (Vector2(int(pos.x), int(pos.y)) - Vector2(164, 96)) / Vector2(64, 32)
	var coords = Vector2(int(vector.x), int(vector.y))
	
	# Extend boundaries
	if vector.x < 0:
		coords.x = -1
	if vector.y < 0:
		coords.y = -1
	
	return coords


func getOffGridPosition(ownPos):
	match pushDirection:
		PushDirection.LEFT:
			ownPos += Vector2(-64, 0)
		PushDirection.RIGHT:
			ownPos += Vector2(64, 0)
		PushDirection.UP:
			ownPos += Vector2(0, -32)
		_:
			ownPos += Vector2(0, 32)
	return ownPos




func populateBoard():
	for y in range(0, 5):
		var row = []
		for x in range(0, 5):
			var instance = spawnNewTile(Vector2(x, y))
			row.append(instance)
		board.append(row)
	
	print(board)


func spawnNewTile(pos):
	var instance = tileNode.instance()
	var color = randi()%3
	var power = randi()%2
	var scaler = Vector2(64, 32)

	instance.setup(color, power)
	instance.position = bp + Vector2(pos.x, pos.y) * scaler
	$platform/tiles.add_child(instance)
	return instance

func _on_Button_button_up():
	Global.fullscreen()


func _on_clickDelay_timeout():
	clickReady = true


