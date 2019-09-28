extends Control


const killsPerPoint = 5
const savePerTurn = 5
const text = "Turns left: "

func _ready():
	updateTurns(1)
	init()

func init():
	$totalHumans.value = 100
	$totalHumansDelay.value = 100
	$savedHumans.value = 0
	percentage()

func updateTurns(count):
	if count <= 1:
		count = "[color=#c93038]" + str(count) + "[/color]"
	elif count <= 2:
		count = "[color=#de6a38]" + str(count) + "[/color]"
	
	$turnWindow/RichTextLabel.bbcode_text = "[center]" + text + str(count) + "[/center]"

func killHumans(pointsLeft):
	var decrement = pointsLeft * killsPerPoint
	$totalHumans.value = max($totalHumans.value - decrement, $savedHumans.value)
	$Tween.interpolate_property($totalHumansDelay, "value", $totalHumansDelay.value, $totalHumans.value, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.2)
	$Tween.start()
	percentage()

func saveHumans():
	$savedHumans.value = min($savedHumans.value + savePerTurn, $totalHumans.value)
	percentage()
	checkConditions()

func checkConditions():
	if $savedHumans.value >= $totalHumans.value:
		get_parent().get_parent().thisIsTheEndTrigger()

func percentage():
	var text = "Saved " + str($savedHumans.value) + "% / " + str($totalHumans.value) + "%"
	$Label.set_text(text)