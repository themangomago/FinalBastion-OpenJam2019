extends Control

const nameTag = "[color=#51c43f]Jolie[/color]: "

const bp = Vector2(164, 96)
onready var tileNode = preload("res://scenes/elements/tile.tscn")

var tutorialTexts = [
"Welcome [color=#4c93ad]Commander[/color] to the [color=#852d66]Final Bastion[/color]! Large meteoroid storms are incoming!",
"Defend the Earth from incoming meteoroids while we are evacuating it.", #1
"Have a look on your screen where the interface is explained.", #2
"Each turn a new turret is available. You can place it at the edges of the board.", #3
"Placing a new turret will move the other turrets in the lane.", #4
"If two turrets of the same type are next to each other they can be [color=#51c43f]upgraded[/color]. ", #5
"When the turn counter is zero. The next meteoroid storm is incoming.", #6
"The indicator states the [color=#c93038]power of the attack[/color] and marks the lane.", #7
"No meteoroid shall reach the Earth! Destroyed turrets, will be replaced immediately.", #8
"Place your turrets wisely to encounter the meteoroid storm. Good Luck, [color=#4c93ad]Commander[/color]." #9
]

var tutorialStep = 0

onready var textNode = $textBg/tutorialText

const tutLevel = [
	[[0,1], [0,1], [1,1], [0,1], [0,1]],
	[[2,1], [0,2], [2,1], [2,2], [2,1]],
	[[1,2], [2,2], [2,2], [2,2], [1,2]],
	[[1,2], [0,2], [1,1], [1,1], [0,2]],
	[[0,1], [1,2], [1,1], [0,1], [2,1]]
]


func nextStep():
	tutorialStep += 1
	$textBg/nextBtn.hide()

	match tutorialStep:
		1:
			$tutOverlay.frame = 0
			animateText(tutorialTexts[1])
		2:
			$tutOverlay.frame = 2
			animateText(tutorialTexts[2])
		3:
			$tutOverlay.frame = 3
			animateText(tutorialTexts[3])
		4:
			$tutOverlay.frame = 3
			animateText(tutorialTexts[4])
		5:
			$tutOverlay.frame = 4
			animateText(tutorialTexts[5])
		6:
			$hud.updateTurns(0)
			$tutOverlay.frame = 5
			animateText(tutorialTexts[6])
		7:
			$tutOverlay.frame = 5
			animateText(tutorialTexts[7])
		8:
			$tutOverlay.frame = 6
			animateText(tutorialTexts[8])
		9:
			$tutOverlay.frame = 0
			animateText(tutorialTexts[9])
			$textBg/nextBtn.show()
		_:
			Global.config.tutorialCompleted = true
			get_parent().changeGameState(Global.GameState.Menu)

func init():

	# Remove all Tiles
	for node in $platform/tiles.get_children():
		$platform/tiles.remove_child(node)
		node.queue_free()
		
	tutorialStep = 0
	$textBg/nextBtn.hide()
	$tutOverlay.frame = 0
	populateTutorial()
	
	$hud.updateTurns(1)
	$attackIndicator.setStrength(6)
	$attackIndicator.position = Vector2(164, 32) + Vector2(64 * 3, 0)
	
	animateText(tutorialTexts[0])

func populateTutorial():
	for y in range(0, 5):
		for x in range(0, 5):
			var instance = tileNode.instance()
			var scaler = Vector2(64, 32)
		
			instance.setup(tutLevel[y][x][0], tutLevel[y][x][1] - 1)
			instance.position = bp + Vector2(x, y) * scaler
			$platform/tiles.add_child(instance)

func animateText(string):
	textNode.set_bbcode(nameTag + string)
	textNode.set_visible_characters(6)
	$textDelay.start()


func _on_textDelay_timeout():
	if textNode.get_visible_characters() < textNode.get_total_character_count():
		textNode.set_visible_characters(textNode.get_visible_characters() + 1)
	else:
		$textBg/nextBtn.show()
		$textDelay.stop()


func _on_nextBtn_button_up():
	nextStep()
